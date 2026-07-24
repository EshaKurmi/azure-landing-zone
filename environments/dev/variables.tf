variable "location" {
  description = "Azure region for dev spoke resources"
  type        = string
  default     = "centralindia"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "spoke_vnet_address_space" {
  type    = list(string)
  default = ["10.1.0.0/16"]
}

variable "app_subnet_prefix" {
  type    = list(string)
  default = ["10.1.1.0/24"]
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "admin_username" {
  type    = string
  default = "azureadmin"
}

variable "ssh_public_key" {
  description = "SSH public key used to log into the VM (no password auth allowed)"
  type        = string
}

# These come from the hub environment's terraform output.
# CI/CD fetches them automatically; for manual runs, pass them with -var
# or paste them into terraform.tfvars (see terraform.tfvars.example).
variable "hub_vnet_id" {
  type = string
}

variable "hub_vnet_name" {
  type = string
}

variable "hub_resource_group_name" {
  type = string
}

variable "log_analytics_workspace_id" {
  description = "Hub Log Analytics Workspace ID - used to centralize NSG and VM diagnostics"
  type        = string
}

variable "tags" {
  type = map(string)
  default = {
    Project    = "azure-landing-zone"
    Owner      = "cloud-team"
    CostCenter = "dev"
  }
}
