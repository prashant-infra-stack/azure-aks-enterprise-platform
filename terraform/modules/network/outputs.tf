output "vnet_names" {
  value = {
    for k, v in azurerm_virtual_network.vnet :
    k => v.name
  }
}

output "subnet_ids" {
  value = {
    for k, v in azurerm_subnet.subnet :
    k => v.id
  }
}