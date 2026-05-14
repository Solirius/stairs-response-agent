variable "name" {
  description = "Name for the Container App (and prefix for related resources)."
  type        = string
}

variable "acr_name" {
  description = "Name for the Azure Container Registry (alphanumeric, globally unique)."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "app_settings" {
  description = "Non-secret environment variables for the container."
  type        = map(string)
  default     = {}
}

variable "key_vault_uri" {
  description = "URI of the Key Vault the Container App's managed identity will read secrets from."
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}
