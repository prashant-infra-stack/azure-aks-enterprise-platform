resource "azurerm_key_vault" "kv" {
  for_each = var.keyvaults

  name                = each.value.name
  location            = var.location
  resource_group_name = var.rg_name
  tenant_id           = var.tenant_id

  sku_name = each.value.sku_name

  public_network_access_enabled = false   # 🔥 IMPORTANT

  purge_protection_enabled = true
  soft_delete_retention_days = 7

  tags = var.tags
}
resource "azurerm_private_endpoint" "kv_pe" {
  for_each = var.keyvaults

  name                = "${each.key}-pe"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${each.key}-connection"
    private_connection_resource_id = azurerm_key_vault.kv[each.key].id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
}
resource "azurerm_private_dns_zone" "kv_dns" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.rg_name
}
resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  for_each = var.vnet_ids

  name                  = "kv-link-${each.key}"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.kv_dns.name
  virtual_network_id    = each.value
}
resource "azurerm_private_dns_zone_group" "kv_dns_group" {
  for_each = var.keyvaults

  name                 = "${each.key}-dns-group"
  private_endpoint_id  = azurerm_private_endpoint.kv_pe[each.key].id

  private_dns_zone_ids = [
    azurerm_private_dns_zone.kv_dns.id
  ]
}