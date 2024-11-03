
variable "rg_backend_name" {
     type        = string

  description = "The name of the resource group for the backend"

  
}



variable "rg_backend_location" {
     type        = string

  description = "The location of the resource group for the backend"

 

}



variable "sa_backend" {
     type        = string

  description = "The name of the storage account for the backend"

 

}



variable "sc_backend" {
     type        = string

  description = "The name of the storage container for the backend"

 

}



variable "kv_backend_name" {
     type        = string

  description = "The name of the key vault for the backend"



}
variable "sa_backend_access_key_name" {
    type = string
  description = "The name of the key vault secret for the storage account access key"
  
}