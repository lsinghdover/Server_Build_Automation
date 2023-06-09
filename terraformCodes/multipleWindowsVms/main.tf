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
  resource_group_name  = data.azurerm_resource_group.resource_group.name
} 

module "multipleWinVms" { 
  source     = "../modules/windowsVm" 
  rgName    = data.azurerm_resource_group.resource_group.name 
  size       = var.vmSize 
  subnetId  = data.azurerm_subnet.subnet.id 
  for_each   = var.vmDetails 
  vmName       = each.key 
  location   = lookup(each.value, "location", null) 
  adminName = lookup(each.value, "adminName", null) 
  adminPw   = lookup(each.value, "adminPw", null) 
} 