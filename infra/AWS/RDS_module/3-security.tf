resource "aws_security_group" "this" {
  name        = "${local.rds_name}-rds-sg"
  description = "Allow all inbound traffic rds to eks"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "eks_rds_ingress_5432" {
  description                  = "Ingress from EKS to RDS"
  from_port                    = var.rds_port
  to_port                      = var.rds_port
  ip_protocol                  = "tcp"
  security_group_id            = var.eks_sg_id
  referenced_security_group_id = aws_security_group.this.id
  tags = {
    Name = "eks_rds_ingress_5432"
  }
}

resource "aws_vpc_security_group_egress_rule" "eks_rds_egress_5432" {
  description                  = "Egress from EKS to RDS"
  from_port                    = var.rds_port
  to_port                      = var.rds_port
  ip_protocol                  = "tcp"
  security_group_id            = var.eks_sg_id
  referenced_security_group_id = aws_security_group.this.id
  tags = {
    Name = "eks_rds_egress_5432"
  }
}

resource "aws_vpc_security_group_egress_rule" "rds_eks_egress_5432" {
  description                  = "Egress from EKS to RDS"
  from_port                    = var.rds_port
  to_port                      = var.rds_port
  ip_protocol                  = "tcp"
  security_group_id            = aws_security_group.this.id
  referenced_security_group_id = var.eks_sg_id
  tags = {
    Name = "rds_eks_egress_5432"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_eks_ingress_5432" {
  description                  = "Ingress from RDS to EKS"
  from_port                    = var.rds_port
  to_port                      = var.rds_port
  ip_protocol                  = "tcp"
  security_group_id            = aws_security_group.this.id
  referenced_security_group_id = var.eks_sg_id
  tags = {
    Name = "rds_eks_ingress_5432"
  }
}
