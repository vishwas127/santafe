variable "registry_name" {
  description = "Name of the ACR"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{5,50}$", var.registry_name))
    error_message = "registry_name must be 5-50 characters and contain only lowercase letters and numbers."
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

variable "sku" {
  description = "ACR SKU (Basic, Standard, Premium)"
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "sku must be one of Basic, Standard, or Premium."
  }
}

variable "admin_enabled" {
  description = "Enable admin user"
  type        = bool
  default     = false
}

variable "georeplications" {
  description = "List of georeplication configurations (Premium only)"
  type = list(object({
    location                = string
    zone_redundancy_enabled = bool
    tags                    = map(string)
  }))
  default = []

  validation {
    condition     = var.sku == "Premium" || length(var.georeplications) == 0
    error_message = "georeplications can only be configured when sku is Premium."
  }
}

variable "tags" {
  description = "Tags for the ACR"
  type        = map(string)
  default     = {}
}
