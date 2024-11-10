locals {
  workspace_suffix = terraform.workspace == "default" ? "" : terraform.workspace
  rg_name          = "${var.rg_name}-${local.workspace_suffix}"
  sa_name          = "${var.sa_name}${local.workspace_suffix}"

  # Dynamisk `source_content` basert på workspace
  source_content = "<h1>Web page created with Terraform: ${terraform.workspace}</h1>"
}

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
}

resource "azurerm_storage_account" "sa" {
  name                     = lower(local.sa_name)
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document = var.index_document
  }
}

# Oppretter statisk nettside med miljøspesifikt innhold
resource "azurerm_storage_blob" "index_html" {
  name                   = var.index_document
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source_content         = local.source_content
}

output "website_url" {
  value = azurerm_storage_account.sa.primary_web_endpoint
}
