variable "resource_groups" {
  description = "Map of resource groups"
  type        = map(string)
}

variable "location" {
  description = "Azure region"
  type        = string
}