variable "public_subnets" {
  type = map(any)
  default = {
    public_subnet = {
      subnets   = ["10.10.16.0/24", "10.10.4.0/24", "10.10.5.0/24", "10.10.0.0/24", "10.10.64.0/24"]
      is_public = true
    }
  }
}

variable "private_subnets" {
  type = map(any)
  default = {
    private_subnets = {
      subnets   = ["10.10.2.0/24", "10.10.192.0/24", "10.10.3.0/24", "10.10.128.0/24"]
      is_public = false
    }
  }
}


# variable "vpn_subnets" {
#   type = map(any)
#   default = {
#     vpn_subnets = {
#       subnets   = ["10.0.112.0/24"]
#       is_public = false
#       az        = "us-east-1c"
#     }
#   }
# }

# variable "vpn_routes" {
#   type = map(any)
#   default = {
#     route1 = {
#       "route" = ["0.0.0.0/0", "nat_gw"]
#     }
#     route2 = {
#       "route" = ["192.168.156.0/24", "vgw"]
#     }
#   }
# }

variable "staging_private_routes" {
  type = map(any)
  default = {
    route1 = {
      "route" = ["0.0.0.0/0", "nat_gw"]
    }
    # route2 = {
    #   "route" = ["10.0.0.0/16", "vpc_peering_connection"]
    # }
    # route2 = {
    #   "route" = ["192.168.156.0/24", "network_interface"]
    # }
  }
}

variable "staging_public_routes" {
  type = map(any)
  default = {
    route1 = {
      "route" = ["0.0.0.0/0", "internet_gw"]
    }
    # route2 = {
    #   "route" = ["10.0.0.0/16", "vpc_peering_connection"]
    # }
    # route2 = {
    #   "route" = ["192.168.156.27/32", "network_interface"]
    # }
  }
}

variable "staging_nacl_rules" {
  type = map(any)
  default = {
    rule1 = {
      "rule" = ["allow", "0.0.0.0/0", null, null, "-1", 5000, "egress"]
    }
    rule2 = {
      "rule" = ["allow", "0.0.0.0/0", null, null, "-1", 5000, "ingress"]
    }
  }
}




# variable "kafka_sg_rules" {
#   type = map(any)
#   default = {
#     "Allow connections from local" = {
#       from_port          = "0"
#       to_port            = "0"
#       protocol           = "-1"
#       allowed_cidr_block = "10.10.0.0/16"
#     }
#   }
# }


variable "combyn_tg_api_key" {
  sensitive = true
  default   = "M1NQa4nqI0ErwtrjyJvIL5VI58KLHIdAat4eqdwAXZ9WeBuYOLp4z0llfbf3FQGWBAoPi_zrfw1o8OZT-3q203XitG4WGBmVxo5fBlR_CURzCiOctNw0aM6SJFl2xV4J0Ku4fg"
}


variable "tg_network" {
  default = "combyn"
}
