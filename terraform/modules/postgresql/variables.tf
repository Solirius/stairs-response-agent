variable "name" {
  description = "Name of the PostgreSQL Flexible Server."
  type        = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "admin_username" {
  description = "Administrator login username."
  type        = string
}

variable "admin_password" {
  description = "Administrator login password."
  type        = string
  sensitive   = true
}

variable "sku_name" {
  description = "SKU for the PostgreSQL Flexible Server (e.g. B_Standard_B1ms)."
  type        = string
  default     = "B_Standard_B1ms"
}

variable "tags" {
  type    = map(string)
  default = {}
}
