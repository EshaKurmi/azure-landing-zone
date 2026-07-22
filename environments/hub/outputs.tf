output "hub_resource_group_name" {
  value = module.resource_group.name
}

output "hub_vnet_id" {
  value = module.hub_vnet.id
}

output "hub_vnet_name" {
  value = module.hub_vnet.name
}

output "bastion_name" {
  value = module.bastion.name
}

output "log_analytics_workspace_id" {
  value = module.log_analytics.id
}
