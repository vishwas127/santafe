project_name = "devopsinsider"
environment  = "dev"
location     = "East US"

aks_default_node_pool = {
  name                 = "systempool"
  node_count           = 1
  vm_size              = "Standard_DS2_v2"
  auto_scaling_enabled = true
  min_count            = 1
  max_count            = 3
  vnet_subnet_id       = null # Set if using custom VNET
}

aks_additional_node_pools = {
  "userpool1" = {
    vm_size              = "Standard_DS2_v2"
    node_count           = 1
    auto_scaling_enabled = true
    min_count            = 1
    max_count            = 5
    vnet_subnet_id       = null
    mode                 = "User"
  }
}

aks_network_profile = {
  network_plugin = "azure"
  network_policy = "azure"
  service_cidr   = "10.0.0.0/16"
  dns_service_ip = "10.0.0.10"
}

tags = {
  Project = "DevOps Insiders"
  Owner   = "Vishwas"
}
