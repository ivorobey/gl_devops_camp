
provider "aws" {
  region     = "eu-central-1"
  access_key = "" 
  secret_key = "" 
}

# Azure Provider
# provider "azurerm" {
#   features {}

#   subscription_id = "" 
#   client_id       = "" 
#   client_secret   = "" 
#   tenant_id       = "" 
# }

# module "AWS" {
#   source = "./modules/AWS"
# }
# module "Azure" {
#   source = "./modules/Azure"
# }