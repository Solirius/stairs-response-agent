locals {
  base_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = "Solirius Hackathon Team"
  }

  # Resource naming — keep project_name to 8 chars or fewer to stay within Azure name length limits
  rg_name            = "rg-${var.project_name}-${var.environment}-${var.location}"
  postgresql_name    = "psql-${var.project_name}-${var.environment}"
  storage_name       = substr(lower(replace("st${var.project_name}${var.environment}", "-", "")), 0, 24)
  container_app_name = "app-${var.project_name}-${var.environment}"
  acr_name           = substr(lower("acr${var.project_name}${var.environment}"), 0, 50)
  search_name        = "srch-${var.project_name}-${var.environment}"
  ai_foundry_name    = "aif-${var.project_name}-${var.environment}"
  key_vault_name     = substr("kv-${var.project_name}-${var.environment}", 0, 24)
}
