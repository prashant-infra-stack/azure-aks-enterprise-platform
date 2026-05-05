resource "azurerm_public_ip" "pip" {
  for_each = {
    firewall = "firewall"
    bastion  = "bastion"
  }

  name                = "${each.key}-pip"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}
resource "azurerm_firewall" "fw" {
  name                = var.firewall_name
  location            = var.location
  resource_group_name = var.rg_name

  sku_name = "AZFW_VNet"
  sku_tier = "Standard"

  ip_configuration {
    name                 = "fw-config"
    subnet_id            = var.subnet_ids["hub-AzureFirewallSubnet"]
    public_ip_address_id = azurerm_public_ip.pip["firewall"].id
  }

  tags = var.tags
}
resource "azurerm_bastion_host" "bastion" {
  name                = var.bastion_name
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                 = "bastion-config"
    subnet_id            = var.subnet_ids["hub-AzureBastionSubnet"]
    public_ip_address_id = azurerm_public_ip.pip["bastion"].id
  }

  tags = var.tags
}
resource "azurerm_route_table" "rt" {
  name                = "rt-hub"
  location            = var.location
  resource_group_name = var.rg_name

  route {
    name                   = "default-route"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.fw.ip_configuration[0].private_ip_address
  }

  tags = var.tags
}
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-hub"
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}