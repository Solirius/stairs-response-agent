output "endpoint" {
  description = "HTTPS endpoint for the Azure AI Search service."
  value       = "https://${azurerm_search_service.this.name}.search.windows.net"
}

output "primary_key" {
  description = "Primary admin API key for the search service."
  value       = azurerm_search_service.this.primary_key
  sensitive   = true
}

output "name" {
  description = "Name of the search service."
  value       = azurerm_search_service.this.name
}
