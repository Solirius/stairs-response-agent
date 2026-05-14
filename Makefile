.PHONY: help init plan apply destroy fmt validate evidence

-include .env
export

TF_DIR := terraform

help: ## Show this help dialog
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

init: ## Initialize Terraform backend and providers
	@echo "Initializing Terraform..."
	@cd $(TF_DIR) && terraform init

fmt: ## Auto-format all Terraform code
	@echo "Formatting Terraform code..."
	@cd $(TF_DIR) && terraform fmt -recursive

validate: ## Validate configuration syntax
	@echo "Validating Terraform code..."
	@cd $(TF_DIR) && terraform validate

plan: fmt validate ## Run formatting, validation, and output a deployment plan
	@echo "Generating Terraform plan..."
	@cd $(TF_DIR) && TF_VAR_postgresql_admin_password="$(TF_VAR_postgresql_admin_password)" terraform plan -out=tfplan

apply: ## Apply the generated infrastructure plan
	@echo "Applying Terraform configuration..."
	@cd $(TF_DIR) && TF_VAR_postgresql_admin_password="$(TF_VAR_postgresql_admin_password)" terraform apply tfplan

destroy: ## Destroy local environment resources safely
	@echo "Destroying infrastructure..."
	@cd $(TF_DIR) && TF_VAR_postgresql_admin_password="$(TF_VAR_postgresql_admin_password)" terraform destroy

evidence: ## Export ITHC security markdown evidence
	@echo "Executing compliance evidence dump..."
	# Future expansion: ../ithc-evidence/evidence-commands.sh