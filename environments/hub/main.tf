# =========================================================
# HUB ENVIRONMENT
# Contains: Hub VNet, Azure Bastion, Log Analytics Workspace
# Spokes (dev/test/prod) peer into this hub.
# Naming follows Azure CAF abbreviations: rg-, vnet-, snet-, bas-, log-
# =========================================================

module "resource_group" {
  source   = "../../modules/resource-group"
  name     = "rg-${local.workload}"
  location = var.location
  tags     = local.common_tags
}

module "hub_vnet" {
  source              = "../../modules/vnet"
  name                = "vnet-${local.workload}"
  location            = var.location
  resource_group_name = module.resource_group.name
  address_space       = var.hub_vnet_address_space
  tags                = local.common_tags
}

# Azure Bastion requires a subnet literally named "AzureBastionSubnet" - do not rename.
module "bastion_subnet" {
  source                = "../../modules/subnet"
  name                  = "AzureBastionSubnet"
  resource_group_name   = module.resource_group.name
  virtual_network_name  = module.hub_vnet.name
  address_prefixes      = var.bastion_subnet_prefix
}

module "shared_services_subnet" {
  source                = "../../modules/subnet"
  name                  = "snet-shared-services"
  resource_group_name   = module.resource_group.name
  virtual_network_name  = module.hub_vnet.name
  address_prefixes      = var.shared_services_subnet_prefix
}

module "bastion" {
  source              = "../../modules/bastion"
  name                = "bas-${local.workload}"
  location            = var.location
  resource_group_name = module.resource_group.name
  subnet_id           = module.bastion_subnet.id
  sku                 = "Basic"
  tags                = local.common_tags
}

module "log_analytics" {
  source              = "../../modules/log-analytics"
  name                = "log-${local.workload}"
  location            = var.location
  resource_group_name = module.resource_group.name
  retention_in_days   = 30
  tags                = local.common_tags
}
