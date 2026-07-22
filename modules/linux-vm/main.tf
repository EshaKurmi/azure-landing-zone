resource "azurerm_linux_virtual_machine" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    var.network_interface_id
  ]
  tags = var.tags

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  # Cloud-init script that runs on first boot. Lets the VM come up with a
  # real running service (e.g. Nginx) instead of an empty box - so there's
  # something visible to show/screenshot after deployment.
  custom_data = var.custom_data != null ? base64encode(var.custom_data) : null

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = var.boot_diagnostics_storage_uri
  }
}
