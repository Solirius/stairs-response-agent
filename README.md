# Azure-Fabric-Landing-Zone

## Deployment steps

### 1. Prerequisites

- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed
- [Terraform](https://developer.hashicorp.com/terraform/install) installed
- Access to the `solirius-data-practice` Azure subscription

### 2. Log in to Azure

```bash
az login
az account set --subscription "solirius-data-practice"
```

### 3. Create the remote Terraform backend (once per environment)

Run the commands in the [Create remote backend](#to-create-the-remote-backend) section below.
Note the storage account name printed at the end — you'll need it in the next step.

### 4. Configure backend.tf

Edit `terraform/backend.tf` — uncomment the `terraform` block and set your storage account name:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-fabric-tfstate-uksouth"
    storage_account_name = "<your-storage-account-name>"
    container_name       = "tfstate"
    key                  = "compliance-discovery.tfstate"
  }
}
```

### 5. Set the PostgreSQL password

**Fish shell:**

```fish
set -x TF_VAR_postgresql_admin_password "YourSecurePassword123!"
```

**Bash/zsh:**

```bash
export TF_VAR_postgresql_admin_password="YourSecurePassword123!"
```

Never commit this value. It is passed to `make plan` / `make apply` automatically.

### 6. Deploy

```bash
make init    # initialise backend and providers
make plan    # format, validate, and preview all changes
make apply   # provision the infrastructure
```

This will provision:

- Resource Group
- PostgreSQL Flexible Server
- Storage Account
- App Service (Python 3.11, Linux)
- Azure AI Search
- Azure OpenAI (gpt-4o-mini)
- Key Vault (with secrets for DB password, OpenAI key, Search key)

### 7. Destroy (when done)

```bash
make destroy
```

---

## To create the remote backend

```bash
# Log in to Azure
az login

# Set variables (replace with your naming standard/region)
RG_NAME="rg-fabric-tfstate-uksouth"
STORAGE_NAME="stfabrictfstate$(date +%s)" # unique name
CONTAINER_NAME="tfstate"
LOCATION="uksouth"

# Create Resource Group for State
az group create --name $RG_NAME --location $LOCATION

# Create Storage Account with versioning enabled (crucial for recovery during hackdays)
az storage account create \
  --name $STORAGE_NAME \
  --resource-group $RG_NAME \
  --location $LOCATION \
  --sku Standard_LRS \
  --encryption-services blob

# Enable Blob Versioning for safety
az storage account blob-service-properties update \
  --account-name $STORAGE_NAME \
  --resource-group $RG_NAME \
  --enable-versioning true

# Create Blob Container
az storage container create \
  --name $CONTAINER_NAME \
  --account-name $STORAGE_NAME \
  --auth-mode login

echo "Save this storage account name for your backend.tf: $STORAGE_NAME"
```

> **Fish shell note:** Replace `VAR="value"` assignments with `set VAR "value"` and run the
> `az` commands individually using the literal values, as Fish does not support `VAR=value` syntax.
