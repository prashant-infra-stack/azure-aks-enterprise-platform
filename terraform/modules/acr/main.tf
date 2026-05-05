resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.rg_name
  location            = var.location

  sku           = var.sku
  admin_enabled = var.admin_enabled

  tags = var.tags
}
resource "azurerm_role_assignment" "acr_pull" {
  principal_id                     = var.aks_identity_principal_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
}