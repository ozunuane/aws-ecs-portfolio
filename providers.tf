provider "aws" {
  region = "us-east-1"
}

# provider "twingate" {
#   api_token = var.combyn_tg_api_key
#   network   = var.tg_network
# }
# module "backend" {
#   source = "./modules/providers"
#   env    = "staging"
# }

terraform {
  backend "s3" {
    bucket         = "combyn-tf-statefile"
    dynamodb_table = "combyne-tf-statefile-lock"
    encrypt        = true
    key            = "staging/statefile-tf-staging"
    region         = "us-east-1"

  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.65"
    }
    twingate = {
      source  = "Twingate/twingate"
      version = "0.2.1"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}






