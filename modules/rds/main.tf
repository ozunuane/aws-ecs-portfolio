############## subnet, option and parameter groups ##############
resource "aws_db_subnet_group" "staging_subnet_group" {
  name        = "${var.env}-subnet-group"
  description = "${var.env}-subnet-group"
  subnet_ids  = var.private_subnets
  tags = {
    "Environment" = "${var.env}"
  }
}

resource "aws_db_subnet_group" "staging_public_subnet_group" {
  name        = "${var.env}-public-subnet-group"
  description = "${var.env}-public-subnet-group"
  subnet_ids  = var.public_subnets
  tags = {
    "Environment" = "${var.env}"
  }
}

resource "aws_db_option_group" "staging_option_group_mysql_8" {
  name                     = "${var.env}-option-group-mysql-8"
  option_group_description = "${var.env}-option-group-mysql-8"
  engine_name              = "mysql"
  major_engine_version     = "8.0"
  tags = {
    "Environment" = "${var.env}"
  }
}

resource "aws_db_parameter_group" "staging_parameter_group_mysql_8" {
  name        = "${var.env}-parameter-group-mysql-8"
  description = "${var.env}-parameter-group-mysql-8"
  family      = "mysql8.0"
  tags = {
    "Environment" = "${var.env}"
  }
}

module "combyn_staging_db_sg" {
  source       = "../security_group"
  rules        = var.combyn_staging_db_sg_rules
  vpc_id       = var.vpc_id
  service_name = "combyn-staging-db"
}

module "combyn_staging_mysql_db" {
  source                = "./rds_instance"
  db_identifier         = "combyn-staging-mysql-db"
  service_name          = "combyn-mysql"
  instance_class        = "db.t2.micro"
  allocated_storage     = 20
  default_db_name       = "combyn_staging"
  admin_username        = "combyn_admin"
  admin_password        = null
  storage_encrypted     = false
  max_allocated_storage = 1000
  storage_type          = "gp2"
  db_security_group_id  = module.combyn_staging_db_sg.id
  db_subnet_group_name  = aws_db_subnet_group.staging_public_subnet_group.name
  parameter_group_name  = aws_db_parameter_group.staging_parameter_group_mysql_8.name
  publicly_accessible   = false
  apply_immediately     = true
}



module "combyn_staging_postgress_db" {
  source                = "./rds_instance"
  db_identifier         = "combyn-staging-postgres-db"
  service_name          = "combyn-staging-postgres-db"
  instance_class        = "db.t3.small"
  db_engine             = "postgres"
  db_engine_version     = "12.11"
  allocated_storage     = 20
  admin_username        = "postgres"
  admin_password        = null
  storage_encrypted     = false
  max_allocated_storage = 1000
  storage_type          = "gp2"
  db_security_group_id  = module.combyn_staging_db_sg.id
  db_subnet_group_name  = aws_db_subnet_group.staging_public_subnet_group.name
  parameter_group_name  = aws_db_parameter_group.staging_parameter_group_mysql_8.name
  publicly_accessible   = false
  apply_immediately     = true
}
