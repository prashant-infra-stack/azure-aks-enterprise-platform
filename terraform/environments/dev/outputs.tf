output "aks_name" {
  value = module.aks.aks_name
}

output "acr_login_server" {
  value = module.acr.acr_login_server
}

output "appgw_id" {
  value = module.app_gateway.appgw_id
}

output "storage_ids" {
  value = module.storage.storage_ids
}

output "keyvault_ids" {
  value = module.keyvault.keyvault_ids
}

output "database_ids" {
  value = module.database.postgres_ids
}