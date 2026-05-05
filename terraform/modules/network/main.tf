# =========================
# VNET CREATION
# =========================
resource "azurerm_virtual_network" "vnet" {
  for_each = var.vnets

  name                = each.value.name
  address_space       = each.value.address_space
  location            = var.location

  resource_group_name = (
    each.key == "hub"
    ? var.resource_groups["hub_rg"]
    : var.resource_groups["spoke_rg"]
  )
}

# =========================
# LOCALS (SUBNET FLATTENING)
# =========================
locals {
  subnet_map = flatten([
    for vnet_key, subnet_values in var.subnets : [
      for subnet_name, cidr in subnet_values : {
        vnet_key    = vnet_key
        subnet_name = subnet_name
        cidr        = cidr
      }
    ]
  ])
}

# =========================
# SUBNET CREATION
# =========================
resource "azurerm_subnet" "subnet" {
  for_each = {
    for subnet in local.subnet_map :
    "${subnet.vnet_key}-${subnet.subnet_name}" => subnet
  }

  name                 = each.value.subnet_name

  resource_group_name = (
    each.value.vnet_key == "hub"
    ? var.resource_groups["hub_rg"]
    : var.resource_groups["spoke_rg"]
  )

  virtual_network_name = azurerm_virtual_network.vnet[each.value.vnet_key].name
  address_prefixes     = [each.value.cidr]
}