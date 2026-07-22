# Partial backend configuration.
# Actual storage account / resource group values are supplied at `terraform init`
# time via backend.hcl (see backend.hcl.example) - so you NEVER edit this file.
terraform {
  backend "azurerm" {}
}
