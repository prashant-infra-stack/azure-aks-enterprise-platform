variable "storage_accounts" {
  type = map(object({
    name             = string
    account_tier     = string
    account_replication_type = string
  }))
}

variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vnet_ids" {
  type = map(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}