# Hackathon defaults — keep project_name short (max 8 chars) to stay within Azure naming limits.
# Set postgresql_admin_password via environment variable to avoid committing secrets:
#   export TF_VAR_postgresql_admin_password="YourSecurePassword123!"

project_name              = "cmplianz"
environment               = "hack"
location                  = "uksouth"
postgresql_admin_username = "pgadmin"
postgresql_sku            = "B_Standard_B1ms"
search_sku                = "basic"
openai_model              = "gpt-4o"
openai_model_version      = "2024-11-20"
openai_capacity           = 30
embedding_model           = "text-embedding-3-small"
embedding_model_version   = "1"
embedding_capacity        = 30
