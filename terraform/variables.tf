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

variable "search_sku" {
  description = "Pricing tier for Azure AI Search (free, basic, standard)."
  type        = string
  default     = "basic"
}

variable "openai_model" {
  description = "Azure OpenAI model to deploy (e.g. gpt-4o, gpt-4o-mini)."
  type        = string
  default     = "gpt-4o"
}

variable "openai_model_version" {
  description = "Version of the Azure OpenAI model."
  type        = string
  default     = "2024-11-20"
}

variable "openai_capacity" {
  description = "TPM quota for the OpenAI deployment in thousands (Standard tier)."
  type        = number
  default     = 30
}

variable "openai_location" {
  description = "Azure region for the OpenAI account. gpt-4o-mini is not available in uksouth; swedencentral and eastus have the widest model support."
  type        = string
  default     = "swedencentral"
}

variable "embedding_model" {
  description = "Azure OpenAI embedding model to deploy."
  type        = string
  default     = "text-embedding-3-small"
}

variable "embedding_model_version" {
  description = "Version of the embedding model (use '1' for text-embedding-3-small)."
  type        = string
  default     = "1"
}

variable "embedding_capacity" {
  description = "TPM quota in thousands for the embedding deployment."
  type        = number
  default     = 30
}
