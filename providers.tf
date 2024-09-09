terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "ds-build-agent-rg"
    storage_account_name = "dsbuildagentstatesa"
    container_name       = "tfstate"
    key                  = "tfstate"
  }
}

provider "azurerm" {
  features {}
}