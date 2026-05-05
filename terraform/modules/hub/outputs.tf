output "firewall_private_ip" {
  value = azurerm_firewall.fw.ip_configuration[0].private_ip_address
}

output "bastion_id" {
  value = azurerm_bastion_host.bastion.id
}