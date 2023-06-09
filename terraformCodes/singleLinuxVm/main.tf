terraform {
  required_version = "v1.1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.90"
    }
  }
}

provider "azurerm" {
  features {
    virtual_machine {
      delete_os_disk_on_deletion     = true
      skip_shutdown_and_force_delete = true
    }
  }
}

//since we have resource group already available we are just using a reference to that resource group
data "azurerm_resource_group" "resource_group" {
  name = var.rgName
}

//reference to existing virtual network
data "azurerm_virtual_network" "vnet" {
  name                = var.vnetName
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

//reference to existing subnet
data "azurerm_subnet" "subnet" {
  name                 = var.subnetName
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.resource_group.name
}

//creating nic for linux vm to deploy
resource "azurerm_network_interface" "netinterface" {
  name                = "${var.vmName}-nic"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

//creating linux vm
resource "azurerm_linux_virtual_machine" "lnxVm" {
  name                = var.vmName
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = var.location
  size                = var.size
  admin_username      = var.adminName
  disable_password_authentication= false
  admin_password      = var.adminPw
  network_interface_ids = [
    azurerm_network_interface.netinterface.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  tags={
      environment="test"
      location="EUS"
      OpCo="DIT"
  }
}