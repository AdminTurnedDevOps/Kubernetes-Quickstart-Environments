variable "name" {
  type = string
  default = "aksenvironment-vkubelet-01"
}

variable "resource_group_name" {
  type = string
  default = "devrelasaservice"
}

variable "location" {
  type = string
  default = "eastus"
}

variable "node_count" {
  type = string
  default = 3
}