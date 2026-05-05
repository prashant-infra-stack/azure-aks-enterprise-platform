module "resource_group" {
  source = "../../modules/resource_group"

  resource_groups = var.resource_groups
  location        = var.location
}
module "network" {
  source = "../../modules/network"

  vnets           = var.vnets
  subnets         = var.subnets
  resource_groups = var.resource_groups
  location        = var.location
}
module "hub" {
  source = "../../modules/hub"

  rg_name    = var.resource_groups["hub_rg"]
  location   = var.location
  vnet_name  = var.vnets["hub"].name

  subnet_ids = module.network.subnet_ids

  firewall_name = "fw-hub"
  bastion_name  = "bastion-hub"
}
module "spoke" {
  source = "../../modules/spoke"

  spoke_rg         = var.resource_groups["spoke_rg"]
  hub_rg           = var.resource_groups["hub_rg"]
  location         = var.location

  spoke_vnet_name  = var.vnets["spoke"].name
  hub_vnet_name    = var.vnets["hub"].name

  subnet_ids       = module.network.subnet_ids
}
module "aks" {
  source = "../../modules/aks"

  rg_name   = var.resource_groups["spoke_rg"]
  location  = var.location

  aks_name  = "aks-dev"
  dns_prefix = "aksdev"

  kubernetes_version = "1.29"

  subnet_id = module.network.subnet_ids["spoke-aks"]

  private_cluster_enabled = true

  node_pools = {
    default = {
      vm_size    = "Standard_DS2_v2"
      node_count = 2
    }
  }
}
module "acr" {
  source = "../../modules/acr"

  acr_name = "acrdevprashant123"  # unique

  rg_name  = var.resource_groups["spoke_rg"]
  location = var.location

  sku            = "Standard"
  admin_enabled  = false

  aks_identity_principal_id = module.aks.aks_id  # 🔥 important linkage
}
module "storage" {
  source = "../../modules/storage"

  storage_accounts = var.storage_accounts

  rg_name  = var.resource_groups["spoke_rg"]
  location = var.location

  subnet_id = module.network.subnet_ids["spoke-private_ep"]

  vnet_ids = {
    hub   = module.network.vnet_names["hub"]
    spoke = module.network.vnet_names["spoke"]
  }
}
module "keyvault" {
  source = "../../modules/keyvault"

  keyvaults = var.keyvaults

  rg_name   = var.resource_groups["spoke_rg"]
  location  = var.location
  tenant_id = var.tenant_id

  subnet_id = module.network.subnet_ids["spoke-private_ep"]

  vnet_ids = {
    hub   = module.network.vnet_names["hub"]
    spoke = module.network.vnet_names["spoke"]
  }
}
module "database" {
  source = "../../modules/database"

  databases = var.databases

  rg_name  = var.resource_groups["spoke_rg"]
  location = var.location

  subnet_id = module.network.subnet_ids["spoke-db"]

  vnet_ids = {
    hub   = module.network.vnet_names["hub"]
    spoke = module.network.vnet_names["spoke"]
  }
}
module "private_dns" {
  source = "../../modules/private_dns"

  rg_name  = var.resource_groups["hub_rg"]
  location = var.location

  acr_id   = module.acr.acr_id

  subnet_id = module.network.subnet_ids["spoke-private_ep"]

  vnet_ids = {
    hub   = module.network.vnet_names["hub"]
    spoke = module.network.vnet_names["spoke"]
  }
}
module "app_gateway" {
  source = "../../modules/application_gateway"

  appgw_name = "appgw-dev"

  rg_name  = var.resource_groups["spoke_rg"]
  location = var.location

  subnet_id = module.network.subnet_ids["spoke-appgw"]

  sku_name = "Standard_v2"
  sku_tier = "Standard_v2"
  capacity = 2
}
module "monitoring" {
  source = "../../modules/monitoring"

  workspace_name = "log-dev"

  rg_name  = var.resource_groups["spoke_rg"]
  location = var.location

  retention_days = 30
}