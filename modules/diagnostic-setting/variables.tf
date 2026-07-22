variable "name" {
  description = "Name of the diagnostic setting"
  type        = string
}

variable "target_resource_id" {
  description = "Resource ID of the resource being monitored (NSG, VM, VNet, etc.)"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Destination Log Analytics Workspace ID"
  type        = string
}

variable "log_categories" {
  description = "List of log category names to enable (varies by resource type)"
  type        = list(string)
  default     = []
}

variable "metric_categories" {
  description = "List of metric category names to enable"
  type        = list(string)
  default     = ["AllMetrics"]
}
