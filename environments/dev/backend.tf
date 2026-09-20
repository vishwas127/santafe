terraform {
  backend "azurerm" {
    resource_group_name  = "rg-aks-dev"
    storage_account_name = "stterraformstate78688"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}