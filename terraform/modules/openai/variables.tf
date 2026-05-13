variable "name" {
  description = "Name of the Azure OpenAI cognitive account."
  type        = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  description = "Azure region. Note: Azure OpenAI availability varies by region — swedencentral and eastus have the widest model support."
  type        = string
}

variable "model_name" {
  description = "OpenAI model to deploy (e.g. gpt-4o-mini, gpt-4o)."
  type        = string
  default     = "gpt-4o-mini"
}

variable "model_version" {
  description = "Version of the OpenAI model."
  type        = string
  default     = "2024-07-18"
}

variable "capacity" {
  description = "TPM quota in thousands (Standard tier). Check your subscription quota before increasing."
  type        = number
  default     = 30
}

variable "tags" {
  type    = map(string)
  default = {}
}
