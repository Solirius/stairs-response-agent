data "azurerm_client_config" "current" {}

module "resource_group" {
  source              = "./modules/resource-groups"
  resource_group_name = local.rg_name
  location            = var.location
  tags                = local.base_tags
}

module "postgresql" {
  source              = "./modules/postgresql"
  name                = local.postgresql_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  admin_username      = var.postgresql_admin_username
  admin_password      = var.postgresql_admin_password
  sku_name            = var.postgresql_sku
  tags                = local.base_tags
}

module "storage" {
  source              = "./modules/storage"
  name                = local.storage_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  tags                = local.base_tags
}

module "container_app" {
  source              = "./modules/container-app"
  name                = local.container_app_name
  acr_name            = local.acr_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  app_settings = {
    DATABASE_HOST              = module.postgresql.fqdn
    DATABASE_NAME              = module.postgresql.database_name
    DATABASE_USER              = var.postgresql_admin_username
    DATABASE_PORT              = "5432"
    DATABASE_SSL               = "require"
    AZURE_OPENAI_ENDPOINT      = module.ai_foundry.endpoint
    AZURE_AI_DEPLOYMENT        = module.ai_foundry.deployment_name
    AZURE_EMBEDDING_DEPLOYMENT = module.ai_foundry.embedding_deployment_name
    SEARCH_ENDPOINT            = module.ai_search.endpoint
  }
  key_vault_uri = module.key_vault.vault_uri
  tags          = local.base_tags
}

resource "azurerm_key_vault_access_policy" "container_app" {
  key_vault_id = module.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.container_app.principal_id

  secret_permissions = ["Get", "List"]
}

module "ai_search" {
  source              = "./modules/ai-search"
  name                = local.search_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  sku                 = var.search_sku
  tags                = local.base_tags
}

module "ai_foundry" {
  source                  = "./modules/ai-foundry"
  name                    = local.ai_foundry_name
  resource_group_name     = module.resource_group.name
  location                = var.openai_location
  storage_account_id      = module.storage.id
  key_vault_id            = module.key_vault.id
  model_name              = var.openai_model
  model_version           = var.openai_model_version
  capacity                = var.openai_capacity
  embedding_model         = var.embedding_model
  embedding_model_version = var.embedding_model_version
  embedding_capacity      = var.embedding_capacity
  tags                    = local.base_tags
}

module "key_vault" {
  source              = "./modules/key-vault"
  name                = local.key_vault_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
  secrets = {
    postgresql-password = var.postgresql_admin_password
    openai-api-key      = module.ai_foundry.primary_key
    search-api-key      = module.ai_search.primary_key
  }
  tags = local.base_tags
}
