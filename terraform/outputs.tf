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

output "search_endpoint" {
  description = "Azure AI Search endpoint URL."
  value       = module.ai_search.endpoint
}
