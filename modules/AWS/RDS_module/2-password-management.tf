resource "aws_kms_key" "this" {
  count       = var.manage_master_user_password ? 1 : 0
  description = "${local.rds_name}-kms-key"
}
