variable "rg_name" {
  type        = string
  description = "Navn på ressursgruppen"
}

variable "rg_location" {
  type        = string
  default     = "westeurope"
  description = "Lokasjon for ressursgruppen"
}

variable "sa_name" {
  type        = string
  description = "Navn på storage account"
}
