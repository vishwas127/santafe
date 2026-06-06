project_name = "santafe"
environment  = "prod"
location     = "centralindia"

aks_role_based_access_control_enabled = true
aks_api_server_authorized_ip_ranges   = ["0.0.0.0/32"] # Replace with your actual IP ranges

aks_default_node_pool = {
  name                 = "default"
  node_count           = 2
  vm_size              = "Standard_B2ms"
  auto_scaling_enabled = true
  min_count            = 2
  max_count            = 5
}

aks_network_profile = {
  network_plugin = "azure"
  network_policy = "azure"
  service_cidr   = "10.3.0.0/16"
  dns_service_ip = "10.3.0.10"
}
