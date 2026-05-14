resource "azurerm_cognitive_account" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  kind                = "AIServices"
  sku_name            = "S0"
  tags                = var.tags
}

resource "azurerm_cognitive_deployment" "this" {
  name                 = var.model_name
  cognitive_account_id = azurerm_cognitive_account.this.id

  model {
    format  = "OpenAI"
    name    = var.model_name
    version = var.model_version
  }

  sku {
    name     = "Standard"
    capacity = var.capacity
  }
}

resource "azurerm_ai_foundry" "hub" {
  name                = "${var.name}-hub"
  resource_group_name = var.resource_group_name
  location            = var.location
  storage_account_id  = var.storage_account_id
  key_vault_id        = var.key_vault_id
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_cognitive_deployment" "embeddings" {
  name                 = var.embedding_model
  cognitive_account_id = azurerm_cognitive_account.this.id

  model {
    format  = "OpenAI"
    name    = var.embedding_model
    version = var.embedding_model_version
  }

  sku {
    name     = "GlobalStandard"
    capacity = var.embedding_capacity
  }
}

resource "azurerm_ai_foundry_project" "this" {
  name               = "${var.name}-project"
  location           = var.location
  ai_services_hub_id = azurerm_ai_foundry.hub.id
  tags               = var.tags

  identity {
    type = "SystemAssigned"
  }
}
