variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  description = "Must be the dedicated AzureBastionSubnet (/26 minimum)"
  type        = string
}

variable "sku" {
  type    = string
  default = "Basic"
}

variable "tags" {
  type    = map(string)
  default = {}
}
