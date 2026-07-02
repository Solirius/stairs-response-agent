# Stairs Response Agent — Azure Infrastructure

## Architecture

Target state follows the **Azure AI Foundry** pattern:

```text
User → Container App (FastAPI) → Azure AI Foundry Agent
                                      ├── AI Services / GPT-4o (swedencentral)
                                      ├── Azure AI Search (vector + keyword)
                                      └── PostgreSQL Flexible Server
                                            ↑
                                  Blob Storage (document indexing)
```

Secrets (`postgresql-password`, `openai-api-key`, `search-api-key`) are stored in Key Vault. The Container App has a system-assigned managed identity with `Get`/`List` access; only `AZURE_KEYVAULT_URI` is passed as an env var, and the app fetches secrets from Key Vault at startup.

## Provisioned resources

| Resource | Name pattern | Region |
| --- | --- | --- |
| Resource Group | `rg-<project>-<env>-uksouth` | uksouth |
| PostgreSQL Flexible Server | `psql-<project>-<env>` | uksouth |
| Storage Account + container | `st<project><env>` | uksouth |
| Azure Container Registry (Basic) | `acr<project><env>` | uksouth |
| Container App Environment | `app-<project>-<env>-env` | uksouth |
| Container App | `app-<project>-<env>` | uksouth |
| Log Analytics Workspace | `app-<project>-<env>-logs` | uksouth |
| Azure AI Search | `srch-<project>-<env>` | uksouth |
| AI Services (AIServices kind) | `aif-<project>-<env>` | swedencentral |
| GPT-4o deployment | `gpt-4o` (Standard, 30K TPM) | swedencentral |
| text-embedding-3-small deployment | `text-embedding-3-small` (GlobalStandard, 30K TPM) | swedencentral |
| Azure AI Foundry Hub | `aif-<project>-<env>-hub` | swedencentral |
| Azure AI Foundry Project | `aif-<project>-<env>-project` | swedencentral |
| Key Vault | `kv-<project>-<env>` | uksouth |

> **Why swedencentral for AI?** `gpt-4o` with Standard SKU is not available in `uksouth`. AI Services, the Foundry Hub and Project are all co-located in `swedencentral` for this reason.

## Deployment steps

### 1. Prerequisites

- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed
- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5.0 installed
- Access to the target Azure subscription
- The following Azure Resource providers must be enabled in your Azure subscription
  - `Microsoft.Storage`

### 2. Log in to Azure

```bash
az login
az account set --subscription "<your-subscription-name>"
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

The password is **never committed** — set it via `.env` (copied from the template) or as an environment variable.

**Option A — `.env` file (recommended for local development):**

```bash
cp .env.example .env   # if an example exists, otherwise create .env
# Edit .env and set:
# TF_VAR_postgresql_admin_password=YourSecurePassword123!
```

The Makefile reads `.env` automatically via `-include .env` + `export`.

**Option B — environment variable:**

```fish
# Fish shell
set -x TF_VAR_postgresql_admin_password "YourSecurePassword123!"
```

```bash
# Bash / zsh
export TF_VAR_postgresql_admin_password="YourSecurePassword123!"
```

### 6. Review terraform.tfvars

Key values to check in `terraform/terraform.tfvars`:

```hcl
project_name         = "cmplianz"      # max 8 chars — used in all resource names
environment          = "hack"
location             = "uksouth"       # main region for most resources
openai_location      = "swedencentral" # AI Services + Foundry must be here for gpt-4o
openai_model         = "gpt-4o"
openai_model_version = "2024-11-20"
```

### 7. Deploy

Run these from the **project root** (where the `Makefile` lives):

```bash
make init    # initialise backend and providers
make plan    # format, validate, and preview all changes
make apply   # provision the infrastructure
```

If `make` cannot find the target (e.g. running from a subdirectory), run Terraform directly:

```bash
cd terraform
terraform init
TF_VAR_postgresql_admin_password="..." terraform plan -out=tfplan
terraform apply tfplan
```

### 8. Known subscription quota constraints

These issues were encountered on the hackathon subscription and are fixed in the current config:

| Error | Cause | Fix applied |
| --- | --- | --- |
| App Service 401 quota (`Total VMs: 0`) | Subscription-level App Service limit | Switched to Azure Container Apps (no VM quota required) |
| `gpt-4o-mini` not available in `uksouth` | Regional model restriction | Moved AI Services to `swedencentral` |
| `gpt-4o-mini 2024-07-18` deprecated | Model retired 31/03/2026 | Switched to `gpt-4o 2024-11-20` |
| `gpt-4o GlobalStandard` quota 0 | No GlobalStandard quota on subscription | Switched to `Standard` SKU |
| `text-embedding-3-small Standard` not in `swedencentral` | SKU not available in region | Switched embedding deployment to `GlobalStandard` |
| PostgreSQL zone change blocked | Can't modify zone without HA pairing | Restored `zone = "1"` to match deployed state |
| `Microsoft.App` provider not registered | Container Apps namespace not registered | `az provider register --namespace Microsoft.App` |

### 9. Redeploying the container image

After code changes, rebuild and push the image, then trigger a new revision:

```bash
# From the housing-association-compliance-db directory
az acr build \
  --registry acrcmplianzhack \
  --image compliance-api:latest \
  .

# Update the running Container App
az containerapp update \
  --name app-cmplianz-hack \
  --resource-group rg-cmplianz-hack-uksouth \
  --image acrcmplianzhack.azurecr.io/compliance-api:latest
```

Terraform uses `ignore_changes` on the container image so it won't revert CLI-driven image updates on the next `terraform apply`.

### 10. Destroy (when done)

```bash
make destroy
```

---

## To create the remote backend

Run `sh init_remote_backend.sh` to initialise the backend.

> **Fish shell note:** Replace `VAR="value"` assignments with `set VAR "value"` and run the
> `az` commands individually using the literal values, as Fish does not support `VAR=value` syntax.
