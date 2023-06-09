output "vmIdOut" {
  value = azurerm_windows_virtual_machine.vm.id
}

output "vmIpOut" {
value = azurerm_network_interface.netinterface.private_ip_addresses
}