terraform {
  required_version = "v1.4.2"
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

//creating nic for windows vm to deploy
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

//creating windows vm
resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.vmName
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = var.location
  size                = var.size
  admin_username      = var.adminName
  admin_password      = var.adminPw
  enable_automatic_updates = false
  patch_mode = "Manual"
  network_interface_ids = [
    azurerm_network_interface.netinterface.id,
  ]

  # storage_os_disk {
  #   name              = "${var.prefix}-os-disk"
  #   create_option     = "FromImage"
  #   managed_disk_type = "Standard_SSD"
  # }

  #   storage_data_disk {
  #   name              = "home-disk"
  #   managed_disk_type = "Premium_LRS"
  #   disk_size_gb      = 128
  #   create_option     = "FromImage"
  #   lun               = 0
  # }

  # storage_data_disk {
  #   name              = "u01-disk"
  #   managed_disk_type = "Premium_LRS"
  #   disk_size_gb      = 128
  #   create_option     = "FromImage"
  #   lun               = 1
  # }

  # storage_data_disk {
  #   name              = "backup-disk-0"
  #   managed_disk_type = "Premium_LRS"
  #   disk_size_gb      = 128
  #   create_option     = "FromImage"
  #   lun               = 2
  # }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
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