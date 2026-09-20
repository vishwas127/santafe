variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9-]{1,63}$", var.cluster_name))
    error_message = "cluster_name must be 1-63 characters and contain only letters, numbers, and hyphens."
  }
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

  validation {
    condition     = can(regex("^[A-Za-z0-9-]{1,54}$", var.dns_prefix))
    error_message = "dns_prefix must be 1-54 characters and contain only letters, numbers, and hyphens."
  }
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

  validation {
    condition = (
      var.default_node_pool.node_count >= 1 &&
      (!var.default_node_pool.auto_scaling_enabled ||
        (var.default_node_pool.min_count != null &&
          var.default_node_pool.max_count != null &&
          var.default_node_pool.min_count >= 1 &&
          var.default_node_pool.max_count >= var.default_node_pool.min_count &&
          var.default_node_pool.node_count >= var.default_node_pool.min_count &&
      var.default_node_pool.node_count <= var.default_node_pool.max_count))
    )
    error_message = "The default node pool must have at least one node; when autoscaling is enabled, min_count and max_count must bound node_count."
  }
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

  validation {
    condition = alltrue([
      for name, pool in var.additional_node_pools :
      can(regex("^[a-z][a-z0-9]{0,11}$", name)) &&
      pool.node_count >= 1 &&
      (!pool.auto_scaling_enabled ||
        (pool.min_count != null &&
          pool.max_count != null &&
          pool.min_count >= 1 &&
          pool.max_count >= pool.min_count &&
          pool.node_count >= pool.min_count &&
      pool.node_count <= pool.max_count))
    ])
    error_message = "Additional node pool names must be 1-12 lowercase alphanumeric characters starting with a letter, and autoscaling bounds must include node_count."
  }
}

variable "network_profile" {
  description = "Network profile configuration"
  type = object({
    network_plugin = string
    network_policy = optional(string, "azure")
    service_cidr   = optional(string)
    dns_service_ip = optional(string)
    pod_cidr       = optional(string)
  })
  default = null

  validation {
    condition = var.network_profile == null || (
      contains(["azure", "kubenet", "none"], var.network_profile.network_plugin) &&
      (var.network_profile.network_policy == null || contains(["azure", "calico", "none"], var.network_profile.network_policy))
    )
    error_message = "network_profile must use a supported network_plugin (azure, kubenet, or none) and network_policy (azure, calico, or none)."
  }
}

variable "role_based_access_control_enabled" {
  description = "Whether RBAC is enabled"
  type        = bool
  default     = true
}

variable "api_server_authorized_ip_ranges" {
  description = "Authorized IP ranges for API server access"
  type        = list(string)
  default     = []
}

variable "acr_id" {
  description = "ACR ID for role assignment (optional)"
  type        = string
  default     = null

  validation {
    condition     = !var.enable_acr_pull_role || var.acr_id != null
    error_message = "acr_id must be set when enable_acr_pull_role is true."
  }
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
