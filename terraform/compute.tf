# compute.tf

data "azurerm_key_vault" "example" {
  name                = "MySecureVault12345"
  resource_group_name = "permaRG"
}

data "azurerm_key_vault_secret" "vm_admin_password" {
  name         = "tommy-password"
  key_vault_id = data.azurerm_key_vault.example.id
}

# Virtual machine
resource "azurerm_virtual_machine" "main" { 
  name                  = "my-vm"
  location              = "westeurope"
  resource_group_name   = "my-resource-group"
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_B1s"
  delete_os_disk_on_termination = "true"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdiskpancho"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "myvm"
    admin_username = "tommy"
    admin_password = data.azurerm_key_vault_secret.vm_admin_password.value
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  # Ensure the VM is destroyed before the NIC and resource group
  depends_on = [
    azurerm_network_interface.main,
    azurerm_network_interface_security_group_association.vm_nic_nsg
  ]
}