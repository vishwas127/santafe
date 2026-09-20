output "aks_cluster_name" {
  description = "AKS cluster name for kubectl configuration."
  value       = module.aks.cluster_name
}

output "aks_kube_config" {
  description = "Raw kubeconfig for deploying Kubernetes manifests."
  value       = module.aks.kube_config
  sensitive   = true
}

output "acr_login_server" {
  description = "ACR login server for image references in manifests."
  value       = module.acr.acr_login_server
}
