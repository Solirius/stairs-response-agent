variable "name" {
  description = "Name of the App Service (must be globally unique)."
  type        = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "sku_name" {
  description = "App Service Plan SKU (e.g. B1, P1v2)."
  type        = string
  default     = "B1"
}

variable "app_settings" {
  description = "Application settings (environment variables) for the web app."
  type        = map(string)
  default     = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
