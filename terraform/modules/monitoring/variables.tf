variable "workspace_name" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "retention_days" {
  type = number
}

variable "tags" {
  type    = map(string)
  default = {}
}