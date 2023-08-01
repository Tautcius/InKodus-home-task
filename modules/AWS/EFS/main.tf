data "aws_vpc" "this" {
  id = var.vpc_id
}

resource "aws_efs_file_system" "test_efs" {
  creation_token = "${var.env}-efs"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = {
    Name = var.env
  }
}

resource "aws_efs_mount_target" "efs_mt_test" {
  for_each        = nonsensitive(toset(var.subnets_private))
  file_system_id  = aws_efs_file_system.test_efs.id
  subnet_id       = each.key
  security_groups = [var.eks_sg_id]
}

/* data "template_file" "efs_storage_class" {
  template = file("${path.module}/efs/storageclass.yaml")
  vars = {
    efs_id = aws_efs_file_system.test_efs.id
    env    = var.env_tag
  }
}
resource "kubectl_manifest" "efs_storage_class" {
  yaml_body = data.template_file.efs_storage_class.rendered
} */

resource "aws_security_group_rule" "efs" {
  description       = "EFS to K8s"
  protocol          = "tcp"
  from_port         = 2049
  to_port           = 2049
  type              = "ingress"
  security_group_id = var.eks_sg_id
  self              = true
  #source_security_group_id = module.eks.cluster_primary_security_group_id
}
