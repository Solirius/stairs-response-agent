output "account_name" {
  description = "Name of the storage account."
  value       = azurerm_storage_account.this.name
}

output "primary_blob_endpoint" {
  description = "Primary blob service endpoint."
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

output "documents_container_name" {
  description = "Name of the documents blob container."
  value       = azurerm_storage_container.documents.name
}
