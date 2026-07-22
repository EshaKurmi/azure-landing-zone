# Generic diagnostic setting module.
# Wires ANY monitorable resource (NSG, VM, VNet, etc.) to a Log Analytics
# Workspace so logs/metrics land in one centralized place - this is what
# actually fulfils "centralized monitoring", not just having a workspace
# sitting unused in the hub.

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = var.name
  target_resource_id        = var.target_resource_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    for_each = var.log_categories
    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = var.metric_categories
    content {
      category = metric.value
      enabled  = true
    }
  }

  lifecycle {
    ignore_changes = [log_analytics_destination_type]
  }
}
