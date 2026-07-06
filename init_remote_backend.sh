# Ensure you "az login" first, and "az account set --subscription X" into the subscription you want to create your resources in

set -e

# Set variables (replace with your naming standard/region)
RG_NAME="rg-hackathon-tfstate-uksouth"
STORAGE_NAME="stfstate$(date +%s)" # unique name
CONTAINER_NAME="tfstate"
LOCATION="uksouth"


# Register resource providers
az provider register --namespace 'Microsoft.App'
az provider register --namespace 'Microsoft.Storage' --wait

# Create Resource Group for State
RESOURCE_GROUP_ID=$(az group create --name $RG_NAME --location $LOCATION --query id --output tsv)

az resource wait --exists --ids $RESOURCE_GROUP_ID

# Create Storage Account with versioning enabled (crucial for recovery during hackdays)
STORAGE_ID=$(
    az storage account create \
    --name $STORAGE_NAME \
    --resource-group $RG_NAME \
    --location $LOCATION \
    --sku Standard_LRS \
    --encryption-services blob \
    --query id \
    --output tsv
)

az resource wait --exists --ids $STORAGE_ID

# Enable Blob Versioning for safety
az storage account blob-service-properties update \
  --account-name $STORAGE_NAME \
  --resource-group $RG_NAME \
  --enable-versioning true

az resource wait --exists --ids $STORAGE_ID

# Create Blob Container
CONTAINER_ID=$(
    az storage container create \
    --name $CONTAINER_NAME \
    --account-name $STORAGE_NAME \
    --auth-mode login \
    --query id \
    --output tsv
)

echo "Save this storage account name for your backend.tf: $STORAGE_NAME"
