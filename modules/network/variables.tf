variable "vnet_name" {
  description = "Name of the VNet"
  type        = string
}

variable "resource_group_name" {
  description = "RG name"
  type        = string
}

variable "location" {
  description = "Location"
  type        = string
}

variable "address_space" {
  description = "VNet address space"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  description = "Map of subnets to create"
  type = map(object({
    address_prefixes = list(string)
  }))
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}
