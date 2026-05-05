variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_ids" {
  description = "All VNets to link DNS"
  type        = map(string)
}

variable "acr_id" {
  type = string
}

variable "subnet_id" {
  description = "Private endpoint subnet"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}