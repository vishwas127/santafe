project_name = "santafe"
environment  = "dev"
location     = "westindia"

aks_role_based_access_control_enabled = true
aks_api_server_authorized_ip_ranges   = ["0.0.0.0/32"] # Replace with your actual IP ranges

aks_default_node_pool = {
  name                 = "default"
  node_count           = 1
  vm_size              = "Standard_B2ms"
  auto_scaling_enabled = true
  min_count            = 1
  max_count            = 3
}

aks_network_profile = {
  network_plugin = "azure"
  network_policy = "azure"
  service_cidr   = "10.2.0.0/16"
  dns_service_ip = "10.2.0.10"
}
