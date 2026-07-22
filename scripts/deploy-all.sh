#!/bin/bash
# =========================================================
# Deploys hub, then dev, test, prod spokes in the correct order.
# Automatically pulls hub outputs into each spoke's variables -
# you don't need to copy/paste anything manually.
#
# Usage: ./scripts/deploy-all.sh plan|apply
# =========================================================
set -e
ACTION=${1:-plan}
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo ">>> [1/4] Hub environment"
cd "$ROOT_DIR/environments/hub"
terraform init -backend-config=backend.hcl
terraform $ACTION -var-file=terraform.tfvars ${ACTION_EXTRA:-}

if [ "$ACTION" = "apply" ]; then
  HUB_VNET_ID=$(terraform output -raw hub_vnet_id)
  HUB_VNET_NAME=$(terraform output -raw hub_vnet_name)
  HUB_RG_NAME=$(terraform output -raw hub_resource_group_name)
  LAW_ID=$(terraform output -raw log_analytics_workspace_id)

  for ENV in dev test prod; do
    echo ">>> Deploying $ENV spoke"
    cd "$ROOT_DIR/environments/$ENV"
    terraform init -backend-config=backend.hcl
    terraform apply -auto-approve \
      -var-file=terraform.tfvars \
      -var="hub_vnet_id=$HUB_VNET_ID" \
      -var="hub_vnet_name=$HUB_VNET_NAME" \
      -var="hub_resource_group_name=$HUB_RG_NAME" \
      -var="log_analytics_workspace_id=$LAW_ID"
  done
else
  echo ">>> Plan-only run. Deploy spokes individually with real hub values after hub is applied."
fi
