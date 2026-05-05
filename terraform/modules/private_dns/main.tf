resource "azurerm_private_dns_zone" "acr_dns" {
  name                = "privatelink.azurecr.io"
  resource_group_name = var.rg_name

  tags = var.tags
}
resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  for_each = var.vnet_ids

  name                  = "link-${each.key}"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.acr_dns.name
  virtual_network_id    = each.value
}
resource "azurerm_private_endpoint" "acr_pe" {
  name                = "acr-private-endpoint"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "acr-connection"
    private_connection_resource_id = var.acr_id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  tags = var.tags
}
resource "azurerm_private_dns_zone_group" "acr_dns_group" {
  name                 = "acr-dns-group"
  private_endpoint_id  = azurerm_private_endpoint.acr_pe.id

  private_dns_zone_ids = [
    azurerm_private_dns_zone.acr_dns.id
  ]
}