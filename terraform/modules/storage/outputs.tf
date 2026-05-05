output "storage_ids" {
  value = {
    for k, v in azurerm_storage_account.sa :
    k => v.id
  }
}