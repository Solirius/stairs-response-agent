variable "project_name" {
  description = "Short project name used in resource naming (lowercase, no spaces, max 8 chars)."
  type        = string
}

variable "environment" {
  description = "Deployment environment label (e.g. hack, dev, prod)."
  type        = string
  default     = "hack"
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "uksouth"
}

variable "postgresql_admin_username" {
  description = "Administrator login for PostgreSQL Flexible Server."
  type        = string
  default     = "pgadmin"
}

variable "postgresql_admin_password" {
  description = "Administrator password for PostgreSQL Flexible Server."
  type        = string
  sensitive   = true
}

variable "postgresql_sku" {
  description = "SKU for PostgreSQL Flexible Server."
  type        = string
  default     = "B_Standard_B1ms"
}

variable "app_service_sku" {
  description = "SKU for App Service Plan (e.g. B1, P1v2)."
  type        = string
  default     = "B1"
}

variable "search_sku" {
  description = "Pricing tier for Azure AI Search (free, basic, standard)."
  type        = string
  default     = "basic"
}

variable "openai_model" {
  description = "Azure OpenAI model to deploy (e.g. gpt-4o-mini, gpt-4o)."
  type        = string
  default     = "gpt-4o-mini"
}

variable "openai_model_version" {
  description = "Version of the Azure OpenAI model."
  type        = string
  default     = "2024-07-18"
}

variable "openai_capacity" {
  description = "TPM quota for the OpenAI deployment in thousands (Standard tier)."
  type        = number
  default     = 30
}
