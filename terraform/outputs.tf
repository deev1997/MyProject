output "vm_public_ip" {
  description = "The public IP address of the VM"
  value       = azurerm_public_ip.vm_public_ip.ip_address
  depends_on  = [
    azurerm_virtual_machine.main,
    azurerm_network_interface.main,
    azurerm_public_ip.vm_public_ip
  ]
}

output "vm_id" {
  description = "The ID of the VM"
  value       = azurerm_virtual_machine.main.id
}

output "vm_name" {
  description = "The name of the VM"
  value       = azurerm_virtual_machine.main.name
}
