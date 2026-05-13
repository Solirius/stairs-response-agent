variable "name" {
  description = "Name of the Azure AI Search service."
  type        = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "sku" {
  description = "Pricing tier: free, basic, standard, standard2, standard3."
  type        = string
  default     = "basic"
}

variable "tags" {
  type    = map(string)
  default = {}
}
