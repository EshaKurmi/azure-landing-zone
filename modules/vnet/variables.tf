variable "name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group to deploy the VNet in"
  type        = string
}

variable "address_space" {
  description = "Address space for the VNet"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
