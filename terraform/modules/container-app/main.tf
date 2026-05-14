resource "azurerm_log_analytics_workspace" "this" {
  name                = "${var.name}-logs"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_container_registry" "this" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
  tags                = var.tags
}

resource "azurerm_container_app_environment" "this" {
  name                       = "${var.name}-env"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  tags                       = var.tags
}

resource "azurerm_container_app" "this" {
  name                         = var.name
  container_app_environment_id = azurerm_container_app_environment.this.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"
  tags                         = var.tags

  secret {
    name  = "acr-password"
    value = azurerm_container_registry.this.admin_password
  }
  secret {
    name  = "database-password"
    value = var.database_password
  }
  secret {
    name  = "openai-api-key"
    value = var.openai_api_key
  }
  secret {
    name  = "search-api-key"
    value = var.search_api_key
  }

  registry {
    server               = azurerm_container_registry.this.login_server
    username             = azurerm_container_registry.this.admin_username
    password_secret_name = "acr-password"
  }

  template {
    container {
      name   = "app"
      image  = "${azurerm_container_registry.this.login_server}/compliance-api:latest"
      cpu    = 0.25
      memory = "0.5Gi"

      dynamic "env" {
        for_each = var.app_settings
        content {
          name  = env.key
          value = env.value
        }
      }

      env {
        name        = "DATABASE_PASSWORD"
        secret_name = "database-password"
      }
      env {
        name        = "AZURE_OPENAI_API_KEY"
        secret_name = "openai-api-key"
      }
      env {
        name        = "SEARCH_API_KEY"
        secret_name = "search-api-key"
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 8000
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  # Prevent Terraform from reverting the image after az acr build + az containerapp update
  lifecycle {
    ignore_changes = [template[0].container[0].image]
  }
}
