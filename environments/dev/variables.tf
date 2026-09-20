variable "project_name" {
  description = "Project name used for naming"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,18}[a-z0-9]$", var.project_name))
    error_message = "project_name must be 3-20 lowercase letters, numbers, or hyphens, and start and end with a letter or number."
  }
}

variable "environment" {
  description = "Environment (dev, test, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment must be one of dev, test, or prod."
  }
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

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.acr_sku)
    error_message = "acr_sku must be one of Basic, Standard, or Premium."
  }
}

variable "aks_kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = null
}

variable "aks_default_node_pool" {
  description = "Default node pool config"
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

variable "aks_additional_node_pools" {
  description = "Additional node pools"
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

variable "aks_network_profile" {
  description = "Network profile"
  type = object({
    network_plugin = string
    network_policy = optional(string, "azure")
    service_cidr   = optional(string)
    dns_service_ip = optional(string)
    pod_cidr       = optional(string)
  })
  default = null
}

variable "aks_role_based_access_control_enabled" {
  description = "Whether RBAC is enabled for AKS"
  type        = bool
  default     = true
}

variable "aks_api_server_authorized_ip_ranges" {
  description = "Authorized IP ranges for AKS API server"
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for cidr in var.aks_api_server_authorized_ip_ranges : can(cidrhost(cidr, 0))])
    error_message = "aks_api_server_authorized_ip_ranges must contain valid IPv4 or IPv6 CIDR ranges."
  }
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}
