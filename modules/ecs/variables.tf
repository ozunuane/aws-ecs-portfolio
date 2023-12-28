variable "env" {
  default = "staging"
}

variable "vpc_id" {

}



variable "private_subnets" {

}



variable "public_subnets" {

}
variable "combyn-zone_id" {

}

variable "pulsar_lb" {

}




variable "staging_lb" {
}

#####################################  USER SERVICE  ###########################################################################
## security group rule  #####


variable "user_svc_rules" {

  default = {
    "Allow connections from local" = {
      from_port          = "1"
      to_port            = "65535"
      protocol           = "tcp"
      allowed_cidr_block = "10.10.0.0/16"
    }
  }
}



variable "user_service_staging_env" {
  default = [

    {
      "name" : "SERVICE_NAME",
      "value" : "sv.user"
    },

    {
      "name" : "USER_SERVICE_PORT",
      "value" : "5000"
    },
    {
      "name" : "APP_ENV",
      "value" : "staging"
    },
  ]
}


variable "user_service_staging_secrets" {
  default = [

    {
      "valueFrom" : "/software/staging/mongo/database/name"
      "name" : "DATABASE_NAME"
    },

    {
      "valueFrom" : "/software/staging/mongo/database/url"
      "name" : "DATABASE_URL"
    },

    {
      "valueFrom" : "/software/staging/pulsar_url"
      "name" : "PULSAR_URL"
    },

    {

      "valueFrom" : "/software/staging/redisaddress"
      "name" : "REDIS_ADDRESS"
    },



    {
      "valueFrom" : "/software/staging/jwt_secret"
      "name" : "SECRET_KEY"
    }



  ]
}

#############################################################################3##################








#############################3########  EXPENSE SERVICE    ############################################
## security group rule  #####


variable "expense_svc_rules" {

  default = {
    "Allow connections from local" = {
      from_port          = "1"
      to_port            = "65535"
      protocol           = "tcp"
      allowed_cidr_block = "10.10.0.0/16"
    }
  }
}



variable "expense_service_staging_env" {
  default = [

    {
      "name" : "SERVICE_NAME",
      "value" : "sv.expense"
    },

    {
      "name" : "EXPENSE_SERVICE_PORT",
      "value" : "5001"
    },
    {
      "name" : "APP_ENV",
      "value" : "staging"
    }
  ]
}

variable "expense_service_staging_secrets" {
  default = [

    {
      "valueFrom" : "/software/staging/mongo/database/name"
      "name" : "DATABASE_NAME"
    },

    {
      "valueFrom" : "/software/staging/mongo/database/url"
      "name" : "DATABASE_URL"
    },

    {
      "valueFrom" : "/software/staging/pulsar_url"
      "name" : "PULSAR_URL"
    }

  ]
}

########################################################################################################












#################################### Notify SERVICE    ##############################################
## security group rule  #####


variable "notify_svc_rules" {

  default = {
    "Allow connections from local" = {
      from_port          = "1"
      to_port            = "65535"
      protocol           = "tcp"
      allowed_cidr_block = "10.10.0.0/16"
    }
  }
}



variable "notify_staging_env" {
  default = [

    {
      "name" : "SERVICE_NAME",
      "value" : "sv.notify"
    },

    {
      "name" : "NOTIFY_SERVICE_PORT",
      "value" : "5002"
    },

    {
      "name" : "APP_ENV",
      "value" : "staging"
    }
  ]
}

variable "notify_service_staging_secrets" {

  default = [

    {
      "valueFrom" : "/software/staging/mongo/database/name"
      "name" : "DATABASE_NAME"
    },

    {
      "valueFrom" : "/software/staging/mongo/database/url"
      "name" : "DATABASE_URL"
    },

    {
      "valueFrom" : "/software/staging/pulsar_url"
      "name" : "PULSAR_URL"
    },

    { "valueFrom" : "/software/staging/redisaddress"
      "name" : "REDIS_ADDRESS"
    },

    {
      "valueFrom" : "/software/staging/jwt_secret"
      "name" : "SECRET_KEY"
    }
  ]
}

#####################################################################################################








#############   API  SERVICE    #################
## security group rule  #####


variable "api_svc_rules" {

  default = {
    "Allow connections from local" = {
      from_port          = "1"
      to_port            = "65535"
      protocol           = "tcp"
      allowed_cidr_block = "10.10.0.0/16"
    }
  }
}



variable "api_service_staging_env" {
  default = [

    {
      "name" : "APP_ENV",
      "value" : "staging"
    },


    {
      "name" : "CORE_API_SERVICE_PORT",
      "value" : "5003"
    }



  ]
}

variable "api_service_staging_secrets" {
  default = [

    {
      "valueFrom" : "/software/staging/mongo/database/name"
      "name" : "DATABASE_NAME"
    },

    {
      "valueFrom" : "/software/staging/mongo/database/url"
      "name" : "DATABASE_URL"
    },

    {
      "valueFrom" : "/software/staging/pulsar_url"
      "name" : "PULSAR_URL"
    },
    {
      "valueFrom" : "/software/staging/user_service/baseurl"
      "name" : "USER_SERVICE_URL"
    },
    {
      "valueFrom" : "/software/staging/expense_service/baseurl"
      "name" : "EXPENSE_SERCVICE_URL"
    },
    {
      "valueFrom" : "/software/staging/notify_service/baseurl"
      "name" : "NOTIFICATION_SERVICE_URL"
    }

  ]
}



variable "frontend_staging_rules" {

  default = {
    "Allow connections from local" = {
      from_port          = "1"
      to_port            = "65535"
      protocol           = "tcp"
      allowed_cidr_block = "10.10.0.0/16"
    }
  }
}



############################  mongo ################################################################




# variable "mongo_efs_sg_rules" {
#   default = {
#     "Allow connections from local" = {
#       from_port          = "0"
#       to_port            = "0"
#       protocol           = "-1"
#       allowed_cidr_block = "10.10.0.0/16"
#     }
#   }
# }

variable "mongo_svc_rules" {

  default = {
    "Allow connections from local" = {
      from_port          = "0"
      to_port            = "0"
      protocol           = "-1"
      allowed_cidr_block = "10.10.0.0/16"
    }
  }
}



variable "mongodb_svc_secrets" {
  default = [


    # {
    #   "valueFrom" : "/software/staging/mongo/init/root_username"
    #   "name" : "MONGO_INITDB_ROOT_USERNAME"
    # },


    # {
    #   "valueFrom" : "/software/staging/mongo/init/root_password"
    #   "name" : "MONGO_INITDB_ROOT_PASSWORD"
    # },

    # {
    #   "valueFrom" : "/software/staging/mongo/init/db_name"
    #   "name" : "MONGO_INITDB_DATABASE"
    # }
  ]

}

# mongodb://combyn:combynstaging@doc-db-staging.cluster-ccicpef7sths.us-east-1.docdb.amazonaws.com:27017/?authMechanism=DEFAULT&tls=true&tlsCAFile=%2FUsers%2Fozi%2FDesktop%2Fkeys%2Fglobal-bundle.pem