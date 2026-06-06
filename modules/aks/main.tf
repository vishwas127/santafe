# tfsec:ignore:azure-container-logging # tfsec:ignore:azure-container-limit-authorized-ips
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  role_based_access_control_enabled = var.role_based_access_control_enabled

  dynamic "api_server_access_profile" {
    for_each = length(var.api_server_authorized_ip_ranges) > 0 ? [1] : []
    content {
      authorized_ip_ranges = var.api_server_authorized_ip_ranges
    }
  }

  dynamic "default_node_pool" {
    for_each = [var.default_node_pool]
    content {
      name                        = default_node_pool.value.name
      node_count                  = default_node_pool.value.node_count
      vm_size                     = default_node_pool.value.vm_size
      auto_scaling_enabled        = default_node_pool.value.auto_scaling_enabled
      min_count                   = default_node_pool.value.auto_scaling_enabled ? default_node_pool.value.min_count : null
      max_count                   = default_node_pool.value.auto_scaling_enabled ? default_node_pool.value.max_count : null
      vnet_subnet_id              = default_node_pool.value.vnet_subnet_id
      temporary_name_for_rotation = lookup(default_node_pool.value, "temporary_name_for_rotation", "tempnodepool")

      dynamic "upgrade_settings" {
        for_each = lookup(default_node_pool.value, "upgrade_settings", null) != null ? [default_node_pool.value.upgrade_settings] : []
        content {
          max_surge = upgrade_settings.value.max_surge
        }
      }
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = var.network_profile != null ? var.network_profile.network_plugin : "azure"
    network_policy = var.network_profile != null ? (var.network_profile.network_policy != null ? var.network_profile.network_policy : "azure") : "azure"
    service_cidr   = var.network_profile != null ? var.network_profile.service_cidr : null
    dns_service_ip = var.network_profile != null ? var.network_profile.dns_service_ip : null
    pod_cidr       = var.network_profile != null ? var.network_profile.pod_cidr : null
  }

  tags = merge(
    {
      "ResourceName" = var.cluster_name
    },
    var.tags
  )
}

resource "azurerm_kubernetes_cluster_node_pool" "additional" {
  for_each = var.additional_node_pools

  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = each.value.vm_size
  node_count            = each.value.node_count
  auto_scaling_enabled  = each.value.auto_scaling_enabled
  min_count             = each.value.auto_scaling_enabled ? each.value.min_count : null
  max_count             = each.value.auto_scaling_enabled ? each.value.max_count : null
  vnet_subnet_id        = each.value.vnet_subnet_id
  mode                  = each.value.mode

  tags = var.tags
}

# Role Assignment for ACR (Conditional)
resource "azurerm_role_assignment" "aks_acr" {
  count = var.enable_acr_pull_role ? 1 : 0

  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.acr_id
  skip_service_principal_aad_check = true
}
