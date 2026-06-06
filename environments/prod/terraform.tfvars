project_name = "devopsinsider"
environment  = "prod"
location     = "East US"

aks_default_node_pool = {
  name                 = "systempool"
  node_count           = 3
  vm_size              = "Standard_DS3_v2"
  auto_scaling_enabled = true
  min_count            = 3
  max_count            = 10
  vnet_subnet_id       = null
}

aks_additional_node_pools = {
  "userpool1" = {
    vm_size              = "Standard_DS3_v2"
    node_count           = 3
    auto_scaling_enabled = true
    min_count            = 3
    max_count            = 20
    vnet_subnet_id       = null
    mode                 = "User"
  }
}

aks_network_profile = {
  network_plugin = "azure"
  network_policy = "azure"
  service_cidr   = "10.1.0.0/16"
  dns_service_ip = "10.1.0.10"
}

tags = {
  Project     = "DevOps Insiders"
  Owner       = "Vishwas"
  Environment = "Production"
}
