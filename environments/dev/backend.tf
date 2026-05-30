terraform {
  backend "azurerm" {
    # These values should ideally be passed via backend-config or environment variables
    # For this generic setup, I'll leave them as placeholders or comments
    # resource_group_name  = "rg-terraform-state"
    # storage_account_name = "stterraformstate"
    # container_name       = "tfstate"
    # key                  = "dev.terraform.tfstate"
  }
}
