variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default = "ds-build-agent-rg"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default = "West Europe"
}

variable "prefix" {
  type = string
  default = "ds-build-agent"
}