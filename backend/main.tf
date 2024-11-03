# Definerer Terraform og Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }


backend "azurerm" {
  resource_group_name   = "backend-rg-RJ"     # Eksisterende ressursgruppe for backend
  storage_account_name  = "rjiac2023rm14y2"         # Eksisterende Storage Account
  container_name        = "tfstate-rj"            # Eksisterende container
  key                   = "backend.terraform.tfstate"
}
  
  }

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

# Generer en tilfeldig streng som kan brukes i ressursnavn
resource "random_string" "random_string_id" {
  length  = 6
  special = false
  upper   = false
}

# Oppretter en ressursgruppe for backend-lagring
resource "azurerm_resource_group" "backend_rg_RJme" {
  name     = var.rg_backend_name
  location = var.rg_backend_location
}

# Oppretter en Storage Account for backend
resource "azurerm_storage_account" "sa_backend_RJ" {
  name                     = "${lower(var.sa_backend)}${random_string.random_string_id.result}"
  resource_group_name      = azurerm_resource_group.backend_rg_RJme.name
  location                 = azurerm_resource_group.backend_rg_RJme.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

# Oppretter en Storage Container i Storage Account
resource "azurerm_storage_container" "sc_backend_RJ" {
  name                  = var.sc_backend
  storage_account_name  = azurerm_storage_account.sa_backend_RJ.name
  container_access_type = "private"
}

# Henter klientkonfigurasjon for å bruke tenant- og objekt-ID i access policy
data "azurerm_client_config" "current" {}

# Oppretter en Key Vault for lagring av hemmeligheter
resource "azurerm_key_vault" "examplekv_backend" {
  name                        = "${var.kv_backend_name}${random_string.random_string_id.result}"
  location                    = azurerm_resource_group.backend_rg_RJme.location
  resource_group_name         = azurerm_resource_group.backend_rg_RJme.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"

 # Tilgangspolicy for Key Vault
access_policy {
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  key_permissions = ["Get", "List", "Create"]
  secret_permissions = ["Get", "Set", "List"]
  storage_permissions = ["Get", "Set", "List"]
}

}

# Oppretter en hemmelighet i Key Vault for Storage Account tilgangsnøkkel
resource "azurerm_key_vault_secret" "sa_backend_access_key" {
  name         = var.sa_backend_access_key_name
  value        = azurerm_storage_account.sa_backend_RJ.primary_access_key
  key_vault_id = azurerm_key_vault.examplekv_backend.id
}
