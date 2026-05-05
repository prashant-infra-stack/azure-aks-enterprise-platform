variable "keyvaults" {
  type = map(object({
    name       = string
    sku_name   = string
  }))
}

variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tenant_id" {
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