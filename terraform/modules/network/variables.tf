variable "vnets" {
  type = map(object({
    name          = string
    address_space = list(string)
  }))
}

variable "subnets" {
  type = map(map(string))
}

variable "resource_groups" {
  type = map(string)
}

variable "location" {
  type = string
}