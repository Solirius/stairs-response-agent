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

module "app_service" {
  source              = "./modules/app-service"
  name                = local.app_service_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  sku_name            = var.app_service_sku
  app_settings = {
    DATABASE_HOST   = module.postgresql.fqdn
    DATABASE_NAME   = module.postgresql.database_name
    DATABASE_USER   = var.postgresql_admin_username
    DATABASE_PORT   = "5432"
    OPENAI_ENDPOINT = module.openai.endpoint
    SEARCH_ENDPOINT = module.ai_search.endpoint
  }
  tags = local.base_tags
}

module "ai_search" {
  source              = "./modules/ai-search"
  name                = local.search_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  sku                 = var.search_sku
  tags                = local.base_tags
}

module "openai" {
  source              = "./modules/openai"
  name                = local.openai_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  model_name          = var.openai_model
  model_version       = var.openai_model_version
  capacity            = var.openai_capacity
  tags                = local.base_tags
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
    openai-api-key      = module.openai.primary_key
    search-api-key      = module.ai_search.primary_key
  }
  tags = local.base_tags
}
