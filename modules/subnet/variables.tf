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

variable "associate_nsg" {
  description = "Whether to create the NSG association. Must be a plain boolean, not derived from nsg_id, because nsg_id is often unknown at plan time on first apply (count cannot depend on an unknown value)."
  type        = bool
  default     = false
}
