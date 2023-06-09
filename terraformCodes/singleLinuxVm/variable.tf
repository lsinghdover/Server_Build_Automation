variable "rgName" {
  type = string
  description = "the name of the resource group for the server"
}

variable "vnetName" {
    type = string
    description = "vnet name of existing virtual network"
}

variable "subnetName" {
    type = string
    description = "subnet name of existing subnet in given virtual network"
}

variable "location" {
  type = string
  description = "the location for the deployment"
}

variable "vmName" {
  type = string
  description = "the name of the VM"
}

variable "size" {
  type = string
  description = "The size of the VM"
}

variable "adminName" {
  type = string
  description = "the local admin account, cannot be administrator"
}

variable "adminPw" {
  type = string
  sensitive = true
  description = "the local admin password, must be 12 char or longer"
}