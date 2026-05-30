locals {
  # Advanced method: Using functions for naming conventions
  resource_group_name = lower(format("rg-%s-%s", var.project_name, var.environment))
  acr_name            = replace(lower(format("acr%s%s", var.project_name, var.environment)), "-", "")
  aks_cluster_name    = lower(format("aks-%s-%s", var.project_name, var.environment))
  vnet_name           = lower(format("vnet-%s-%s", var.project_name, var.environment))

  # Centralized tagging logic
  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}

module "resource_group" {
  source   = "../../modules/resource_group"
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

module "network" {
  source = "../../modules/network"

  vnet_name           = local.vnet_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  address_space       = ["10.1.0.0/16"]
  subnets = {
    aks_subnet = { address_prefixes = ["10.1.1.0/24"] }
  }
  tags = local.common_tags
}

module "acr" {
  source = "../../modules/acr"

  registry_name       = local.acr_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  sku                 = var.acr_sku
  tags                = local.common_tags
}

module "aks" {
  source = "../../modules/aks"

  cluster_name        = local.aks_cluster_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  dns_prefix          = local.aks_cluster_name
  kubernetes_version  = var.aks_kubernetes_version

  # Dependency injection: using the subnet created by the network module
  default_node_pool = merge(var.aks_default_node_pool, {
    vnet_subnet_id = module.network.subnet_ids["aks_subnet"]
  })

  additional_node_pools = {
    for k, v in var.aks_additional_node_pools : k => merge(v, {
      vnet_subnet_id = module.network.subnet_ids["aks_subnet"]
    })
  }

  network_profile      = var.aks_network_profile
  acr_id               = module.acr.acr_id
  enable_acr_pull_role = true
  tags                 = local.common_tags
}
