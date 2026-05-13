variable "name" {
  description = "Storage account name (lowercase alphanumeric, 3-24 chars, globally unique)."
  type        = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
