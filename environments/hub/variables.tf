variable "location" {
  description = "Azure region for all hub resources"
  type        = string
  default     = "centralindia"
}

variable "environment" {
  type    = string
  default = "hub"
}

variable "hub_vnet_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "bastion_subnet_prefix" {
  type    = list(string)
  default = ["10.0.1.0/26"]
}

variable "shared_services_subnet_prefix" {
  type    = list(string)
  default = ["10.0.2.0/24"]
}

variable "tags" {
  type = map(string)
  default = {
    Project     = "azure-landing-zone"
    Owner       = "cloud-team"
    CostCenter  = "shared"
  }
}
