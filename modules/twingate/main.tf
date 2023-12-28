#import remote network

terraform {
  required_providers {
    twingate = {
      source  = "Twingate/twingate"
      version = "0.2.1"
    }
  }
}



provider "twingate" {
  api_token = var.tg_api_key
  network   = var.tg_network
}


resource "twingate_remote_network" "combyn_staging_vpc" {
  name = "combyn-staging-vpc"

}



#Twingate AMI
data "aws_ami" "twingate" {
  most_recent = true

  filter {
    name   = "name"
    values = ["twingate/images/hvm-ssd/twingate-amd64-*"]
  }

  owners = ["617935088040"] # Twingate
}


#Twingate ec2 instance SG
module "twingate_sg" {
  source       = "../security_group"
  rules        = var.twingate_sg_rules
  vpc_id       = var.vpc_id
  service_name = "twingate-ec2-${var.env}-sg"
}


#Twingate ec2 deployments
module "twingate_instance" {
  source       = "./tg_conn_deploy"
  twingate_ami = data.aws_ami.twingate.id
  key_name     = "pulsar-key"
  tg_network   = var.tg_network
  # key_name     = data.aws_key_pair.admin_key_pair.id
  twingate_sg    = [module.twingate_sg.id]
  aws_subnet_id  = var.aws_subnet_id
  aws_network_id = twingate_remote_network.combyn_staging_vpc.id
}

