output "vmIpOut" {
value = azurerm_network_interface.netinterface.private_ip_addresses
}

output "vmIdOut" {
  value = azurerm_linux_virtual_machine.lnxVm.id
}