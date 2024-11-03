terraform {
  backend "azurerm" {
    resource_group_name   = "backend-rg-RJ"     # Eksisterende ressursgruppe for backend
    storage_account_name  = "rjiac2023rm14y2"         # Eksisterende Storage Account
    container_name        = "tfstate-rj"            # Eksisterende container
    key                   = "test-backend.tfstate"  # Ny nøkkel for testing
  }
}

provider "azurerm" {
  features {}
}

# En enkel ressurs for testing
resource "azurerm_resource_group" "test_rg_rj" {
  name     = "rg-test-rj-backend"
  location = "westeurope"
}
