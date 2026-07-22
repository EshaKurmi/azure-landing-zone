variable "name" {
  description = "Name of the subnet"
  type        = string
}

variable "resource_group_name" {
  type = string
}

variable "virtual_network_name" {
  type = string
}

variable "address_prefixes" {
  description = "Address prefixes for the subnet"
  type        = list(string)
}

variable "nsg_id" {
  description = "NSG ID to associate with this subnet (optional)"
  type        = string
  default     = null
}
