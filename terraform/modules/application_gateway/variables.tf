variable "appgw_name" {
  type = string
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

variable "sku_name" {
  type = string
}

variable "sku_tier" {
  type = string
}

variable "capacity" {
  type = number
}

variable "tags" {
  type    = map(string)
  default = {}
}