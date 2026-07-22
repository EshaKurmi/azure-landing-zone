locals {
  # Azure CAF-style naming: <resource-prefix>-lz-<environment>
  workload = "lz-${var.environment}"

  common_tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "Terraform"
  })
}
