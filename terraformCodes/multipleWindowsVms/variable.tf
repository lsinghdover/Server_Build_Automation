variable "rgName" { 
  type        = string 
  description = "name of existing resource group in which we have to deploy a new vm" 
} 
 
variable "vnetName" { 
  type        = string 
  description = "The name of the existing vnet" 
} 

variable "vmSize" { 
  type        = string 
  description = "size of the new vm to deploy on the existing vnet" 
} 
 
variable "vmDetails" { 
  type = map(object( 
    { 
      adminName = string 
      adminPw   = string 
      location   = string 
    } 
  )) 
  description = "this variable contain the details of multiple window vms" 
} 

variable "subnetName" { 
  type        = string 
  description = "this variable contain the name of subnet available in out vnet" 
} 