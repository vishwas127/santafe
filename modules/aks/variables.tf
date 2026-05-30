variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = null
}

variable "default_node_pool" {
  description = "Default node pool configuration"
  type = object({
    name                        = string
    node_count                  = number
    vm_size                     = string
    auto_scaling_enabled        = optional(bool, false)
    min_count                   = optional(number)
    max_count                   = optional(number)
    vnet_subnet_id              = optional(string)
    temporary_name_for_rotation = optional(string, "tempnodepool")
    upgrade_settings = optional(object({
      max_surge = string
    }))
  })
}

variable "additional_node_pools" {
  description = "Map of additional node pools"
  type = map(object({
    vm_size              = string
    node_count           = number
    auto_scaling_enabled = optional(bool, false)
    min_count            = optional(number)
    max_count            = optional(number)
    vnet_subnet_id       = optional(string)
    mode                 = optional(string, "User")
  }))
  default = {}
}

variable "network_profile" {
  description = "Network profile configuration"
  type = object({
    network_plugin = string
    network_policy = optional(string)
    service_cidr   = optional(string)
    dns_service_ip = optional(string)
    pod_cidr       = optional(string)
  })
  default = null
}

variable "acr_id" {
  description = "ACR ID for role assignment (optional)"
  type        = string
  default     = null
}

variable "enable_acr_pull_role" {
  description = "Whether to enable ACR Pull role assignment"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags for the AKS cluster"
  type        = map(string)
  default     = {}
}
