variable "name" {
  description = "Key Vault name (3-24 chars, globally unique)."
  type        = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tenant_id" {
  description = "Azure AD tenant ID."
  type        = string
}

variable "object_id" {
  description = "Object ID of the principal granted secret management permissions."
  type        = string
}

variable "secrets" {
  description = "Map of secret name to value to store in Key Vault."
  type        = map(string)
  sensitive   = true
  default     = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
