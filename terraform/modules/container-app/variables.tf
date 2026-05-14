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

variable "database_password" {
  description = "PostgreSQL admin password (injected as a Container App secret)."
  type        = string
  sensitive   = true
}

variable "openai_api_key" {
  description = "Azure OpenAI API key (injected as a Container App secret)."
  type        = string
  sensitive   = true
}

variable "search_api_key" {
  description = "Azure AI Search admin key (injected as a Container App secret)."
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}
