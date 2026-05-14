output "app_url" {
  description = "Public HTTPS URL of the Container App."
  value       = "https://${azurerm_container_app.this.latest_revision_fqdn}"
}

output "acr_login_server" {
  description = "Login server URL for the Azure Container Registry."
  value       = azurerm_container_registry.this.login_server
}

output "acr_name" {
  description = "Name of the Azure Container Registry."
  value       = azurerm_container_registry.this.name
}

output "container_app_name" {
  description = "Name of the deployed Container App."
  value       = azurerm_container_app.this.name
}
