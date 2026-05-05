resource "azurerm_postgresql_flexible_server" "pg" {
  for_each = var.databases

  name                = each.value.name
  resource_group_name = var.rg_name
  location            = var.location

  version    = each.value.version
  sku_name   = each.value.sku_name
  storage_mb = each.value.storage_mb

  administrator_login    = each.value.admin_user
  administrator_password = each.value.admin_password

  delegated_subnet_id = var.subnet_id

  private_dns_zone_id = azurerm_private_dns_zone.pg_dns.id

  public_network_access_enabled = false   # 🔥 IMPORTANT

  tags = var.tags
}
resource "azurerm_private_dns_zone" "pg_dns" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.rg_name
}
resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  for_each = var.vnet_ids

  name                  = "pg-link-${each.key}"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.pg_dns.name
  virtual_network_id    = each.value
}