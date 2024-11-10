terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }

  backend "azurerm" {
    resource_group_name   = "backend-rg-RJ"       # Eksisterende ressursgruppe for backend
    storage_account_name  = "rjiac2023rm14y2"     # Eksisterende Storage Account
    container_name        = "tfstate-rj"          # Eksisterende container
    key                   = "test001-backend.tfstate"  # Unik nøkkel for denne tilstanden
  }
}

provider "azurerm" {
  features {}
}
