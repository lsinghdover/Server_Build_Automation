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

data "azurerm_resource_group" "resource_group" {
  name = var.rgName
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnetName
  virtual_network_name = var.vnetName
  resource_group_name  = var.rgName
}

module "LinuxVm" {
  source     = "../modules/LinuxVm"
  rgName    = data.azurerm_resource_group.resource_group.name
  location   = var.vmLocation
  subnetId  = data.azurerm_subnet.subnet.id
  size       = var.vmSize
  count      = var.linuxServerCount
  vmName       = "${var.vmName}${count.index + 1}"
  adminName = "${var.vmUsername}${count.index + 1}"
  adminPw   = "${var.vmUserPw}${count.index + 1}"
}
