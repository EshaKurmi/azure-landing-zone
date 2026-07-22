variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vm_size" {
  description = "VM SKU size"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  type    = string
  default = "azureadmin"
}

variable "ssh_public_key" {
  description = "SSH public key for VM login (no password auth)"
  type        = string
}

variable "network_interface_id" {
  type = string
}

variable "custom_data" {
  description = "Raw cloud-init script (plain text, NOT base64) to run on first boot. Leave null for a plain VM with no auto-provisioning."
  type        = string
  default     = null
}

variable "boot_diagnostics_storage_uri" {
  description = "Storage account blob endpoint for boot diagnostics"
  type        = string
  default     = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
