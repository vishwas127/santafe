variable "project_name" {
  description = "Project name used for naming"
  type        = string
}

variable "environment" {
  description = "Environment (dev, test, prod)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "acr_sku" {
  description = "ACR SKU"
  type        = string
  default     = "Standard"
}

variable "aks_kubernetes_version" {
  description = "K8s version"
  type        = string
  default     = null
}

variable "aks_default_node_pool" {
  description = "Default node pool config"
  type        = any
}

variable "aks_additional_node_pools" {
  description = "Additional node pools"
  type        = any
  default     = {}
}

variable "aks_network_profile" {
  description = "Network profile"
  type        = any
  default     = null
}

variable "aks_role_based_access_control_enabled" {
  description = "Whether RBAC is enabled for AKS"
  type        = bool
  default     = true
}

variable "aks_api_server_authorized_ip_ranges" {
  description = "Authorized IP ranges for AKS API server"
  type        = list(string)
  default     = ["0.0.0.0/32"]
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}
