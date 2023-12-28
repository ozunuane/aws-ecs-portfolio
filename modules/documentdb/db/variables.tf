variable "subnet_ids" {
  description = "List of subnet IDs for DocumentDB cluster"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones for DocumentDB cluster"
  type        = list(string)
}


######## db sg rule ###############
variable "document_db_sg_rules" {
  default = {
    "Allow connections from local" = {
      from_port          = 27017
      to_port            = 27017
      protocol           = "tcp"
      allowed_cidr_block = "10.10.0.0/16"
    },

    "Allow connections from all" = {
      from_port          = 27017
      to_port            = 27017
      protocol           = "tcp"
      allowed_cidr_block = "0.0.0.0/0"
    }

  }
}


variable "env" {

}

variable "vpc_id" {

}

variable "instance_class" {

}


# variable "apply_immediately" {
#   type        = bool
#   description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window"
#   default     = true
# }



# variable "preferred_backup_window" {
#   type        = string
#   default     = "07:00-09:00"
#   description = "Daily time range during which the backups happen"
# }

# variable "preferred_maintenance_window" {
#   type        = string
#   default     = "Mon:22:00-Mon:23:00"
#   description = "The window to perform maintenance in. Syntax: `ddd:hh24:mi-ddd:hh24:mi`."
# }

# variable "cluster_family" {
#   type        = string
#   default     = "docdb3.6"
#   description = "The family of the DocumentDB cluster parameter group. For more details, see https://docs.aws.amazon.com/documentdb/latest/developerguide/db-cluster-parameter-group-create.html"
# }

# variable "engine" {
#   type        = string
#   default     = "docdb"
#   description = "The name of the database engine to be used for this DB cluster. Defaults to `docdb`. Valid values: `docdb`"
# }

# variable "engine_version" {
#   type        = string
#   default     = "3.6.0"
#   description = "The version number of the database engine to use"
# }