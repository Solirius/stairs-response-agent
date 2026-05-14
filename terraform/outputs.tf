output "resource_group_name" {
  description = "Name of the project resource group."
  value       = module.resource_group.name
}

output "app_url" {
  description = "Public URL of the deployed FastAPI application (Container App)."
  value       = module.container_app.app_url
}

output "acr_login_server" {
  description = "Login server for the Azure Container Registry."
  value       = module.container_app.acr_login_server
}

output "postgresql_fqdn" {
  description = "Fully qualified domain name of the PostgreSQL server."
  value       = module.postgresql.fqdn
}

output "foundry_endpoint" {
  description = "Azure AI Services endpoint URL (OpenAI-compatible, accessed via Foundry)."
  value       = module.ai_foundry.endpoint
}

output "foundry_hub_id" {
  description = "Resource ID of the Azure AI Foundry Hub."
  value       = module.ai_foundry.foundry_hub_id
}

output "foundry_project_id" {
  description = "Resource ID of the Azure AI Foundry Project."
  value       = module.ai_foundry.foundry_project_id
}

output "search_endpoint" {
  description = "Azure AI Search endpoint URL."
  value       = module.ai_search.endpoint
}

output "key_vault_uri" {
  description = "URI of the Key Vault storing application secrets."
  value       = module.key_vault.vault_uri
}

output "storage_blob_endpoint" {
  description = "Primary blob endpoint for the documents storage account."
  value       = module.storage.primary_blob_endpoint
}
