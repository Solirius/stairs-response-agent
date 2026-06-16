variable "name" {
  description = "Base name for the AI Services account and Foundry Hub/Project."
  type        = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  description = "Azure region. swedencentral and eastus have the widest model support."
  type        = string
}

variable "model_name" {
  description = "Azure OpenAI model to deploy via AI Foundry (e.g. gpt-4o)."
  type        = string
  default     = "gpt-4o"
}

variable "model_version" {
  description = "Version of the OpenAI model."
  type        = string
  default     = "2024-11-20"
}

variable "capacity" {
  description = "TPM quota in thousands (GlobalStandard tier)."
  type        = number
  default     = 30
}

variable "embedding_model" {
  description = "Azure OpenAI embedding model to deploy."
  type        = string
  default     = "text-embedding-3-small"
}

variable "embedding_model_version" {
  description = "Version of the embedding model."
  type        = string
  default     = "1"
}

variable "embedding_capacity" {
  description = "TPM quota in thousands for the embedding deployment."
  type        = number
  default     = 30
}

variable "tags" {
  type    = map(string)
  default = {}
}
