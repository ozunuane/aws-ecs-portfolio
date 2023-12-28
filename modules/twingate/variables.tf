variable "twingate_sg_rules" {
  default = {
    "Allow connections from local" = {
      from_port          = "1"
      to_port            = "65535"
      protocol           = "tcp"
      allowed_cidr_block = "10.10.0.0/16"
    }
  }
}

variable "env" {
  default = "staging"
}

variable "vpc_id" {

}

variable "aws_subnet_id" {

}

variable "tg_network" {
  default = "ozimede"
}

variable "tg_api_key" {
}


