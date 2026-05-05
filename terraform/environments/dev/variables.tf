variable "location" {
  type = string
}

variable "resource_groups" {
  type = map(string)
}

variable "vnets" {
  type = map(object({
    name          = string
    address_space = list(string)
  }))
}

variable "subnets" {
  type = map(map(string))
}

# STORAGE
variable "storage_accounts" {
  type = map(object({
    name                     = string
    account_tier             = string
    account_replication_type = string
  }))
}

# KEYVAULT
variable "keyvaults" {
  type = map(object({
    name     = string
    sku_name = string
  }))
}

# DATABASE
variable "databases" {
  type = map(object({
    name           = string
    sku_name       = string
    storage_mb     = number
    version        = string
    admin_user     = string
    admin_password = string
  }))
}

# TENANT
variable "tenant_id" {
  type = string
}