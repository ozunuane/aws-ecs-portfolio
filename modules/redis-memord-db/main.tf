############ Staging ##################
module "staging_cluster_sg" {
  source       = "../security_group"
  rules        = var.staging_cluster_rules
  vpc_id       = var.vpc_id
  service_name = "staging-redis-cluster-sg"
}


provider "aws" {
  region = local.region
}

locals {
  region = "us-east-1"
  name   = "memorydb-ex-${replace(basename(path.cwd), "_", "-")}"

  tags = {
    Example     = local.name
    Environment = "staging"
  }
}



################################################################################
# MemoryDB Module
################################################################################

module "memory_db_disabled" {
  source = "../.."

  name   = "${local.name}-disabled"
  create = false
}

module "memory_db" {
  source = "../.."

  # Cluster
  name        = local.name
  description = "Example MemoryDB cluster"

  engine_version             = "6.2"
  auto_minor_version_upgrade = true
  node_type                  = "db.r6gd.xlarge"
  num_shards                 = 2
  num_replicas_per_shard     = 2
  data_tiering               = true

  tls_enabled        = true
  security_group_ids = [module.staging_cluster_sg.id]
  maintenance_window = "sun:23:00-mon:01:30"
  # sns_topic_arn            = aws_sns_topic.example.arn
  snapshot_retention_limit = 7
  snapshot_window          = "05:00-09:00"




  # Users
  users = {
    admin = {
      user_name     = "combyn"
      access_string = "on ~* &* +@all"
      passwords     = [random_password.password["combyn"].result]
      tags          = { user = "combyn" }
    }
    readonly = {
      user_name     = "readonly-user"
      access_string = "on ~* &* -@all +@read"
      passwords     = [random_password.password["readonly"].result]
      tags          = { user = "readonly" }
    }
  }

  # ACL
  acl_name = "${local.name}-acl"
  acl_tags = { acl = "custom" }

  # Parameter group
  parameter_group_name        = "${local.name}-param-group"
  parameter_group_description = "Example MemoryDB parameter group"
  parameter_group_family      = "memorydb_redis6"
  parameter_group_parameters = [
    {
      name  = "activedefrag"
      value = "yes"
    }
  ]
  parameter_group_tags = {
    parameter_group = "custom"
  }

  # Subnet group
  subnet_group_name        = "${local.name}-subnet-group"
  subnet_group_description = "Example MemoryDB subnet group"
  subnet_ids               = var.private_subnets
  subnet_group_tags = {
    subnet_group = "custom"
  }

  tags = local.tags
}



resource "random_password" "password" {
  for_each = toset(["admin", "readonly"])

  length           = 16
  special          = true
  override_special = "_%@"
}