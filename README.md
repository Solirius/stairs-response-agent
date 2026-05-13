# Azure-Fabric-Landing-Zone

## Execution workflow
1. git pull
2. make init
3. make plan
4. make apply


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
  --enable-versioning true

# Create Blob Container
az storage container create \
  --name $CONTAINER_NAME \
  --account-name $STORAGE_NAME

echo "Save this storage account name for your backend.tf: $STORAGE_NAME"
```