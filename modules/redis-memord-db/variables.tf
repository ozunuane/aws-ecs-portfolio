variable "name" {

}


variable "vpc_id" {

}

variable "private_subnets" {

}

variable "staging_cluster_rules" {
  type = map(any)
  default = {
    "Allow connections from dev-front-wapp-lb" = {
      from_port          = "6379"
      to_port            = "6379"
      protocol           = "tcp"
      allowed_cidr_block = "10.10.0.0/16"
    }
  }
}