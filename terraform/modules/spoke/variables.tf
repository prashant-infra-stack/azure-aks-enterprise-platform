variable "spoke_rg" {
  type = string
}

variable "hub_rg" {
  type = string
}

variable "location" {
  type = string
}

variable "spoke_vnet_name" {
  type = string
}

variable "hub_vnet_name" {
  type = string
}

variable "subnet_ids" {
  type = map(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}