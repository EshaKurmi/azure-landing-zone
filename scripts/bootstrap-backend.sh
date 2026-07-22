#!/bin/bash
# =========================================================
# One-time setup: creates the Azure Storage Account that will
# hold all Terraform remote state files for this project.
# Run this ONCE before deploying anything.
# =========================================================
set -e

LOCATION="centralindia"
RG_NAME="tfstate-rg"
CONTAINER_NAME="tfstate"

# Generates a guaranteed-unique, valid storage account name (lowercase, <=24 chars)
SUFFIX=$(date +%s | tail -c 6)
STORAGE_NAME="tfstatelz${SUFFIX}"

echo ">> Creating resource group: $RG_NAME"
az group create --name "$RG_NAME" --location "$LOCATION" --output none

echo ">> Creating storage account: $STORAGE_NAME"
az storage account create \
  --name "$STORAGE_NAME" \
  --resource-group "$RG_NAME" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --encryption-services blob \
  --min-tls-version TLS1_2 \
  --output none

echo ">> Creating blob container: $CONTAINER_NAME"
az storage container create \
  --name "$CONTAINER_NAME" \
  --account-name "$STORAGE_NAME" \
  --auth-mode login \
  --output none

echo ""
echo "============================================================"
echo " Backend storage account created: $STORAGE_NAME"
echo " Copy this name into every environments/<env>/backend.hcl"
echo " (copy from backend.hcl.example first, then edit that line)"
echo "============================================================"
