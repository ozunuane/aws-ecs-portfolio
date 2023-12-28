resource "aws_docdb_subnet_group" "example" {
  name       = "combyn-${var.env}-subnet-group"
  subnet_ids = var.subnet_ids
}


module "documentdb_sg_id" {
  source       = "../../security_group"
  rules        = var.document_db_sg_rules
  vpc_id       = var.vpc_id
  env          = var.env
  service_name = "combyn-documentdb-${var.env}-sg"
}

resource "aws_docdb_cluster_parameter_group" "example" {
  name        = "combyn-${var.env}-parameter-group"
  family      = "docdb3.6"
  description = "example parameter group for DocumentDB"
  parameter {
    name  = "parameter_name"
    value = "parameter_value"
  }
}

resource "aws_docdb_cluster" "example" {
  cluster_identifier  = "${var.env}-combyn-cluster"
  engine              = "docdb"
  engine_version      = "4.0.0"
  availability_zones  = var.availability_zones
  skip_final_snapshot = false # Enable snapshots
  # snapshot_identifier    = "combyn-${var.env}-snapshot" # Name for the snapshot
  apply_immediately       = true
  storage_encrypted       = true
  master_password         = "combyn"
  master_username         = random_password.db_password.result
  db_subnet_group_name    = aws_docdb_subnet_group.example.name
  vpc_security_group_ids  = [module.documentdb_sg_id.id]
  preferred_backup_window = "07:00-09:00"

}


resource "random_password" "db_password" {
  length  = 32
  special = false
}


resource "aws_ssm_parameter" "database_password" {
  name  = "/software/staging/database-password"
  value = random_password.db_password.result
  type  = "SecureString"
}



