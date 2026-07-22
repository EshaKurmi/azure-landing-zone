output "spoke_resource_group_name" {
  value = module.resource_group.name
}

output "spoke_vnet_id" {
  value = module.spoke_vnet.id
}

output "vm_private_ip" {
  value = module.app_vm.private_ip_address
}

output "storage_account_name" {
  value = module.storage_account.name
}
