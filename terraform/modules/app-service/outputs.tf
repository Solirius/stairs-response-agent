output "default_hostname" {
  description = "Default hostname of the App Service."
  value       = azurerm_linux_web_app.this.default_hostname
}

output "id" {
  description = "Resource ID of the App Service."
  value       = azurerm_linux_web_app.this.id
}
