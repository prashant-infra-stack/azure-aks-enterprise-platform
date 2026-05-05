resource "azurerm_storage_account" "sa" {
  for_each = var.storage_accounts

  name                     = each.value.name
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type

  public_network_access_enabled = false  # 🔥 IMPORTANT

  tags = var.tags
}
resource "azurerm_private_endpoint" "storage_pe" {
  for_each = var.storage_accounts

  name                = "${each.key}-pe"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${each.key}-connection"
    private_connection_resource_id = azurerm_storage_account.sa[each.key].id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}
resource "azurerm_private_dns_zone" "storage_dns" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.rg_name
}
resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  for_each = var.vnet_ids

  name                  = "storage-link-${each.key}"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.storage_dns.name
  virtual_network_id    = each.value
}
resource "azurerm_private_dns_zone_group" "storage_dns_group" {
  for_each = var.storage_accounts

  name                 = "${each.key}-dns-group"
  private_endpoint_id  = azurerm_private_endpoint.storage_pe[each.key].id

  private_dns_zone_ids = [
    azurerm_private_dns_zone.storage_dns.id
  ]
}