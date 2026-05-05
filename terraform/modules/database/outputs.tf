output "postgres_ids" {
  value = {
    for k, v in azurerm_postgresql_flexible_server.pg :
    k => v.id
  }
}