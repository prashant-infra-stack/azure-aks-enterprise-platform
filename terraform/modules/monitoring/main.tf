resource "azurerm_log_analytics_workspace" "law" {
  name                = var.workspace_name
  location            = var.location
  resource_group_name = var.rg_name

  sku               = "PerGB2018"
  retention_in_days = var.retention_days

  tags = var.tags
}