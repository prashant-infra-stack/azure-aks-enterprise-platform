output "private_dns_zone_name" {
  value = azurerm_private_dns_zone.acr_dns.name
}

output "private_endpoint_id" {
  value = azurerm_private_endpoint.acr_pe.id
}