output "endpoint" {
  description = "Azure OpenAI endpoint URL."
  value       = azurerm_cognitive_account.this.endpoint
}

output "primary_key" {
  description = "Primary API key for Azure OpenAI."
  value       = azurerm_cognitive_account.this.primary_access_key
  sensitive   = true
}

output "deployment_name" {
  description = "Name of the deployed OpenAI model (use this as the model parameter in API calls)."
  value       = azurerm_cognitive_deployment.this.name
}
