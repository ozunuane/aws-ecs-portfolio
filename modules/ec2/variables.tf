variable "vpc_id" {

}

variable "private_subnets" {

}

variable "https_default_cert_arn" {

}

variable "staging_lb" {

}

variable "pulsar_lb" {

}






variable "combyn-zone_id" {

}


variable "combyn_net_cert" {
}








############Sonarqube##########
variable "dev_frontend_sg_rules" {
  type = map(any)
  default = {

    "Allow connections from local" = {
      from_port          = "1"
      to_port            = "65535"
      protocol           = "tcp"
      allowed_cidr_block = "10.10.0.0/16"
    }
  }
}


############Sonarqube##########
variable "sonar_sg_rules" {
  type = map(any)
  default = {

    "Allow connections from local" = {
      from_port          = "9000"
      to_port            = "9000"
      protocol           = "tcp"
      allowed_cidr_block = "10.10.0.0/16"
    },

    "Allow SSH from efs connections" = {
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      security_groups = "sg-0ea6125218ca980e1"
    },

    "Allow SSH from local connections" = {
      from_port          = 22
      to_port            = 22
      protocol           = "tcp"
      allowed_cidr_block = "0.0.0.0/0"
    }
  }
}



variable "jenkins_sg_rules" {
  type = map(any)
  default = {

    "Allow connections from local" = {
      from_port          = "1"
      to_port            = "65535"
      protocol           = "tcp"
      allowed_cidr_block = "10.10.0.0/16"
    }
  }
}
######## Pulsar sg rule ###############
variable "pulsar_sg_rules" {
  default = {
    "Allow connections from local" = {
      from_port          = 1
      to_port            = 65535
      protocol           = "tcp"
      allowed_cidr_block = "10.10.0.0/16"
    },

    "Allow SSH from local connections" = {
      from_port          = 22
      to_port            = 22
      protocol           = "tcp"
      allowed_cidr_block = "10.10.0.0/16"
    }
  }
}



variable "env" {
  default = "staging"
}

variable "public_subnets" {

}

variable "aws_subnet_id" {

}

variable "sonar_network" {
  default = "combyn"
}


##############################


