
provider "aws" {
  region     = "us-east-2"
  access_key = "" 
  secret_key = "" 
}

provider "azurerm" {
  features {}
}

module "AWS" {
  source = "./modules/AWS"
}
module "Azure" {
  source = "./modules/Azure"
}
