locals {
  rds_name = "${var.env}-${var.rds_engine}"
}

resource "aws_db_parameter_group" "this" {
  name   = "${local.rds_name}-param-group"
  family = var.rds_family
  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "${local.rds_name}-subnet-group"
  subnet_ids = var.database_subnets
}

resource "aws_db_instance" "this" {
  identifier                    = "${local.rds_name}-rds-instance"
  allocated_storage             = var.rds_storage_size
  engine                        = var.rds_engine
  engine_version                = var.rds_engine_version
  instance_class                = var.rds_instance_class
  db_name                       = var.rds_db_name
  username                      = var.rds_db_username
  password                      = var.manage_master_user_password == false ? var.rds_db_password : null
  manage_master_user_password   = var.manage_master_user_password == true ? var.manage_master_user_password : null
  master_user_secret_kms_key_id = var.manage_master_user_password == true ? aws_kms_key.this[0].key_id : null
  skip_final_snapshot           = true
  parameter_group_name          = aws_db_parameter_group.this.name
  db_subnet_group_name          = aws_db_subnet_group.this.name
  vpc_security_group_ids        = [aws_security_group.this.id]
}
