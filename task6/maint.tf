provider "aws" {
  region     = "us-east-2"
  access_key = "" 
  secret_key = "" 
}

provider "azurerm" {
  features {}
  subscription_id = ""
  client_id       = ""
  client_secret   = ""
  tenant_id       = ""
}

module "AWS" {
  source = "./modules/AWS"
}

module "Azure" {
  source = "./modules/Azure"
}
