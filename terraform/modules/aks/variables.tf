variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "aks_name" {
  type = string
}

variable "dns_prefix" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "node_pools" {
  description = "AKS node pools"
  type = map(object({
    vm_size    = string
    node_count = number
  }))
}

variable "subnet_id" {
  type = string
}

variable "private_cluster_enabled" {
  type = bool
}

variable "tags" {
  type    = map(string)
  default = {}
}