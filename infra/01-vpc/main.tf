locals {
  cluster_name = "${var.env}-${var.eks_cluster_name}"
}
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"
  # insert the 23 required variables here 
  name                   = "${local.cluster_name}-vpc"
  cidr                   = var.vpc_cird
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true
  azs                    = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets        = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets         = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  database_subnets       = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24"]


  enable_dns_hostnames                 = true
  enable_dns_support                   = true
  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }

  database_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }

  vpc_tags = {
    Name                                          = "VPC-${var.env}"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
}
