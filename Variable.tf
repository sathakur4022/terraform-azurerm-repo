variable "VMmap" {
    type = map(object({
      vmname = string
      size = string
      
    }))
  default = {
    "vm1" = {
        vmname = "prodvm01"
        size = "Standard_D2s_v3"
      
    }
    "vm2" = {
        vmname = "prodvm02"
        size = "Standard_B2s"
       
    }


  }
}
variable "location-info" {

  type = string
  default = "eastus"
  
}

variable "RGinformation01" {
  type = string
  default = "prodrg"

}

variable "RGinformation02" {
  type = string
  default = "nonprodrg"

}





