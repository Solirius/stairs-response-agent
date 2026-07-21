output "endpoint" {
  description = "AI Services endpoint URL (OpenAI-compatible)."
  value       = azurerm_cognitive_account.this.endpoint
}

output "primary_key" {
  description = "Primary API key for AI Services (use with OpenAI SDK or Azure AI Foundry SDK)."
  value       = azurerm_cognitive_account.this.primary_access_key
  sensitive   = true
}

output "deployment_name" {
  description = "Name of the deployed model — use as the model parameter in API calls."
  value       = azurerm_cognitive_deployment.this.name
}

output "embedding_deployment_name" {
  description = "Name of the embedding model deployment."
  value       = azurerm_cognitive_deployment.embeddings.name
}
