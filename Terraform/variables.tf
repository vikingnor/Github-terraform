variable "location" {
  type        = string
  description = "Lokasjon for ressursen"
}

variable "rg_name" {
  type        = string
  description = "Navn på ressursgruppen"
}

variable "sa_name" {
  type        = string
  description = "Navn på lagringskontoen"
}

variable "index_document" {
  type        = string
  description = "Navn på index-dokumentet"
  default     = "index.html"
}
