# Hackathon defaults — keep project_name short (max 8 chars) to stay within Azure naming limits.
# Set postgresql_admin_password via environment variable to avoid committing secrets:
#   export TF_VAR_postgresql_admin_password="YourSecurePassword123!"

project_name              = "cmplianz"
environment               = "hack"
location                  = "uksouth"
postgresql_admin_username = "pgadmin"
postgresql_sku            = "B_Standard_B1ms"
app_service_sku           = "B1"
search_sku                = "basic"
openai_model              = "gpt-4o-mini"
openai_model_version      = "2024-07-18"
openai_capacity           = 30
