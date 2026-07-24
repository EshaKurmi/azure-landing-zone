# =========================================================
# TEST SPOKE ENVIRONMENT
# Contains: Spoke VNet, App Subnet, NSG, private VM, Storage Account
# Peers with the Hub VNet. No public IPs on the VM.
# Naming follows Azure CAF abbreviations: rg-, vnet-, snet-, nsg-, nic-, vm-, st
# =========================================================

# Guarantees a globally-unique Storage Account name without manual edits.
resource "random_string" "storage_suffix" {
  length  = 5
  special = false
  upper   = false
  numeric = true
}

# Reads the Hub environment's state directly - so hub_vnet_id, hub_vnet_name,
# hub_resource_group_name and the Log Analytics workspace ID never need to be
# copy-pasted into tfvars or CI/CD variables. This is how real teams link
# environments together instead of passing values around manually.
data "terraform_remote_state" "hub" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate-rg"
    storage_account_name = var.tfstate_storage_account_name
    container_name        = "tfstate"
    key                   = "hub.terraform.tfstate"
  }
}

module "resource_group" {
  source   = "../../modules/resource-group"
  name     = "rg-${local.workload}"
  location = var.location
  tags     = local.common_tags
}

module "spoke_vnet" {
  source              = "../../modules/vnet"
  name                = "vnet-${local.workload}"
  location            = var.location
  resource_group_name = module.resource_group.name
  address_space       = var.spoke_vnet_address_space
  tags                = local.common_tags
}

module "app_nsg" {
  source              = "../../modules/nsg"
  name                = "nsg-${local.workload}-app"
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = local.common_tags

  security_rules = [
    {
      name                       = "AllowSSHFromHub"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "10.0.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "AllowHTTPFromHub"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "10.0.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "DenyAllInboundInternet"
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }
  ]
}

module "app_subnet" {
  source                = "../../modules/subnet"
  name                  = "snet-test-app"
  resource_group_name   = module.resource_group.name
  virtual_network_name  = module.spoke_vnet.name
  address_prefixes      = var.app_subnet_prefix
  nsg_id                = module.app_nsg.id
  associate_nsg         = true
}

module "app_nic" {
  source              = "../../modules/nic"
  name                = "nic-${local.workload}-vm01"
  location            = var.location
  resource_group_name = module.resource_group.name
  subnet_id           = module.app_subnet.id
  tags                = local.common_tags
}

module "storage_account" {
  source                         = "../../modules/storage-account"
  name                            = "sttestlz${random_string.storage_suffix.result}"
  resource_group_name            = module.resource_group.name
  location                        = var.location
  public_network_access_enabled   = false
  tags                             = local.common_tags
}

module "app_vm" {
  source                        = "../../modules/linux-vm"
  name                          = "vm-${local.workload}01"
  location                      = var.location
  resource_group_name           = module.resource_group.name
  vm_size                        = var.vm_size
  admin_username                = var.admin_username
  ssh_public_key                 = var.ssh_public_key
  network_interface_id           = module.app_nic.id
  boot_diagnostics_storage_uri   = module.storage_account.primary_blob_endpoint
  custom_data                     = templatefile("${path.module}/../../cloud-init/webserver.sh.tpl", { environment = var.environment })
  tags                            = local.common_tags
}

module "hub_peering" {
  source                     = "../../modules/vnet-peering"
  hub_vnet_name              = data.terraform_remote_state.hub.outputs.hub_vnet_name
  hub_vnet_id                = data.terraform_remote_state.hub.outputs.hub_vnet_id
  hub_resource_group_name    = data.terraform_remote_state.hub.outputs.hub_resource_group_name
  spoke_vnet_name            = module.spoke_vnet.name
  spoke_vnet_id              = module.spoke_vnet.id
  spoke_resource_group_name  = module.resource_group.name
}

# ---- Centralized monitoring: send NSG + VM telemetry to the hub's Log Analytics ----

module "nsg_diagnostics" {
  source                      = "../../modules/diagnostic-setting"
  name                        = "diag-nsg-${local.workload}"
  target_resource_id          = module.app_nsg.id
  log_analytics_workspace_id  = data.terraform_remote_state.hub.outputs.log_analytics_workspace_id
  log_categories              = ["NetworkSecurityGroupEvent", "NetworkSecurityGroupRuleCounter"]
  metric_categories           = []
}

module "vm_diagnostics" {
  source                      = "../../modules/diagnostic-setting"
  name                        = "diag-vm-${local.workload}"
  target_resource_id          = module.app_vm.id
  log_analytics_workspace_id  = data.terraform_remote_state.hub.outputs.log_analytics_workspace_id
  log_categories               = []
  metric_categories           = ["AllMetrics"]
}
