variable "name" {
  description = "Name of the Network Security Group"
  type        = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "security_rules" {
  description = "List of security rule objects"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
