output "resource_group_name" {
  description = "Name of the project resource group."
  value       = module.resource_group.name
}

output "app_service_url" {
  description = "URL of the deployed FastAPI application."
  value       = "https://${module.app_service.default_hostname}"
}

output "postgresql_fqdn" {
  description = "Fully qualified domain name of the PostgreSQL server."
  value       = module.postgresql.fqdn
}

output "openai_endpoint" {
  description = "Azure OpenAI endpoint URL."
  value       = module.openai.endpoint
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
