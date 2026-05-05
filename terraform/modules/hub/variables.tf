variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "subnet_ids" {
  description = "Subnet IDs from network module"
  type        = map(string)
}

variable "firewall_name" {
  type = string
}

variable "bastion_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}