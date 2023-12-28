resource "random_password" "db_password" {
  count            = var.admin_password == "default" ? 1 : 0
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_ssm_parameter" "db_password" {
  count       = var.admin_password == "default" ? 1 : 0
  name        = "/${var.env}/${var.service_name}/db_password"
  description = "${var.service_name} db password"
  type        = "SecureString"
  value       = random_password.db_password[0].result

  tags = {
    Environment = "${var.env}"
  }
}

resource "aws_db_instance" "db_instance" {
  identifier             = var.db_identifier == null ? "${var.service_name}-${var.env}-db" : var.db_identifier
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  storage_type           = var.storage_type
  storage_encrypted      = var.storage_encrypted
  db_name                = var.default_db_name
  username               = var.admin_username
  password               = var.admin_password == "default" ? random_password.db_password[0].result : var.admin_password
  port                   = var.db_port
  vpc_security_group_ids = [var.db_security_group_id]
  db_subnet_group_name   = var.db_subnet_group_name
  parameter_group_name   = var.parameter_group_name == "default" ? null : var.parameter_group_name
  option_group_name      = var.option_group_name == "default" ? null : var.option_group_name
  skip_final_snapshot    = var.skip_final_snapshot
  multi_az               = var.multi_az
  publicly_accessible    = var.publicly_accessible

  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately
  maintenance_window          = var.maintenance_window

  snapshot_identifier   = var.snapshot_identifier
  copy_tags_to_snapshot = var.copy_tags_to_snapshot

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? 100 : null

  backup_retention_period = var.backup_retention_period
  max_allocated_storage   = var.max_allocated_storage

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  deletion_protection = true
}