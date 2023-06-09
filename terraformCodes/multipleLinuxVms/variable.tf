
#variables for multiple linux servers

variable "rgName" {
  type        = string
  description = "name of existing resource group in which we have to deploy a new vm"
}

variable "vnetName" {
  type        = string
  description = "The name of the existing vnet"
}

variable "subnetName" {
  type        = string
  description = "this variable contain the name of subnet available in out vnet"
}

variable "vmName" {
  type        = string
  description = "name of existing windows server"
}

variable "vmUsername" {
  type        = string
  description = "user name for linux vm"
}

variable "linuxServerCount" {
  type        = number
  description = "No. of linux server we want to deploy"
}

variable "vmUserPw" {
  type        = string
  description = "password to log into linux server"
  sensitive   = true
}

variable "vmSize" {
  type        = string
  description = "size of the new vm to deploy on the existing vnet"
}

variable "vmLocation" {
  type        = string
  description = "location of new vm"
}
