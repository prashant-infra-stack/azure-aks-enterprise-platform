resource "azurerm_user_assigned_identity" "aks_identity" {
  name                = "${var.aks_name}-identity"
  location            = var.location
  resource_group_name = var.rg_name
}
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.rg_name
  dns_prefix          = var.dns_prefix

  kubernetes_version = var.kubernetes_version

  private_cluster_enabled = var.private_cluster_enabled

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }

  default_node_pool {
    name           = "default"
    vm_size        = var.node_pools["default"].vm_size
    node_count     = var.node_pools["default"].node_count
    vnet_subnet_id = var.subnet_id
  }

  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"
  }

  role_based_access_control_enabled = true

  tags = var.tags
}
resource "azurerm_kubernetes_cluster_node_pool" "extra" {
  for_each = {
    for k, v in var.node_pools :
    k => v if k != "default"
  }

  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = each.value.vm_size
  node_count            = each.value.node_count

  vnet_subnet_id = var.subnet_id
}