variable "env" {
  default = "staging"
}

variable "private_subnets" {

}

variable "public_subnets" {

}

variable "combyn_staging_db_sg_rules" {
  default = {
    "Allow connections from local" = {
      from_port          = "3306"
      to_port            = "3306"
      protocol           = "tcp"
      allowed_cidr_block = "100.0.0.0/16"
    }

    # "Allow connections from prod" = {
    #   from_port          = "3306"
    #   to_port            = "3306"
    #   protocol           = "tcp"
    #   allowed_cidr_block = "10.0.0.0/16"
    # }


    "Allow connections from public temp" = {
      from_port          = "3306"
      to_port            = "3306"
      protocol           = "tcp"
      allowed_cidr_block = "0.0.0.0/0"
    }

  }
}

variable "vpc_id" {

}


