############ Staging ##################
module "staging_cluster_sg" {
  source       = "../security_group"
  rules        = var.staging_cluster_rules
  vpc_id       = var.vpc_id
  service_name = "staging-redis-cluster-sg"
}

resource "aws_elasticache_subnet_group" "sub_group" {
  name       = "staging-sg"
  subnet_ids = var.private_subnets
}

module "staging_cluster" {
  source               = "./clusters"
  subnets              = var.private_subnets
  security_group_ids   = module.staging_cluster_sg.id
  replication_group_id = "staging-server"
  subnet_group_name    = aws_elasticache_subnet_group.sub_group.name
  create_subnet_group  = false
}



############ QA #################


module "qa_cluster_sg" {
  source       = "../security_group"
  rules        = var.staging_cluster_rules
  vpc_id       = var.vpc_id
  service_name = "qa-redis-cluster-sg"
  env          = "qa"
}

resource "aws_elasticache_subnet_group" "sub_group_qa" {
  name       = "qa-sg"
  subnet_ids = var.private_subnets
}

module "qa_cluster" {
  source               = "./clusters"
  subnets              = var.private_subnets
  security_group_ids   = module.qa_cluster_sg.id
  replication_group_id = "qa-server"
  subnet_group_name    = aws_elasticache_subnet_group.sub_group_qa.name
  create_subnet_group  = false
  parameter_group_name = "qa-parameter-group"
  env                  = "qa"

}

