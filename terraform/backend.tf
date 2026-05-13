# Uncomment and fill in your state storage account name before running terraform init.
# Create the storage account first using the commands in the README.

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-fabric-tfstate-uksouth"
    storage_account_name = "stfabtfstate78688644"
    container_name       = "tfstate"
    key                  = "compliance-discovery.tfstate"
  }
}
