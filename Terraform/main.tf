locals {
  workspace_suffix = terraform.workspace == "default" ? "" : terraform.workspace  # "" som standard hvis det er default
  rg_name          = "${var.rg_name}-${local.workspace_suffix}"
  sa_name          = "${var.sa_name}${local.workspace_suffix}"
}

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.rg_location
}

resource "azurerm_storage_account" "sa" {
  name                     = lower(local.sa_name)
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.rg_location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document = "index.html"
  }
}

# Bruk template_file til å lage en HTML-fil som viser navnet på gjeldende workspace
data "template_file" "index_html" {
  template = <<-EOF
    <html>
    <body>
        <h1>Web page created with Terraform: ${terraform.workspace}</h1>
    </body>
    </html>
  EOF
}

resource "azurerm_storage_blob" "index_html" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = "$web"
  type                   = "Block"
  source_content         = data.template_file.index_html.rendered
  content_type           = "text/html"  # Angi Content-Type for å vise som nettside
}


output "website_url" {
  value = azurerm_storage_account.sa.primary_web_endpoint
}
