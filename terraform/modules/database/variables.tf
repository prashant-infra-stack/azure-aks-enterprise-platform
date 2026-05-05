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