/*

#uncomment the corresponding section which you want to create
#e.g. if you want to create a new subnet to deploy this vm in existing vnet 
#just uncomment subnet block and pass the vnet name as variable
#then use that subnet id (as subnet.id) in network interface

resource "azurerm_resource_group" "resource_group" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-ip-001"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "snet-ip-001"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
*/

resource "azurerm_network_interface" "netinterface" {
  name                = "${var.vmName}-nic"
  location            = var.location
  resource_group_name = var.rgName

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnetId
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.vmName
  resource_group_name = var.rgName
  location            = var.location
  size                = var.size
  admin_username      = var.adminName
  admin_password      = var.adminPw
  enable_automatic_updates = false
  patch_mode = "Manual"
  network_interface_ids = [
    azurerm_network_interface.netinterface.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  tags={
      environment="test"
      location="EUS"
      OpCo="DIT"
  }
}