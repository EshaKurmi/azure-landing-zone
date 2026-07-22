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
  description = "Subnet ID the NIC will be attached to"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
