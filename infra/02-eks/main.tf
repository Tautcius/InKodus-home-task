locals {
  # cluster_name     = "${var.env_tag}-${var.eks_cluster_name}"
  vpc_id           = data.tfe_outputs.vpc.values.vpc_id
  private_subnets  = data.tfe_outputs.vpc.values.vpc_private_subnets
  public_subnets   = data.tfe_outputs.vpc.values.vpc_public_subnets
  database_subnets = data.tfe_outputs.vpc.values.vpc_database_subnets
  subnets          = concat(local.private_subnets)
}
data "tfe_outputs" "vpc" {
  organization = "BTT"
  workspace    = "01-vpc-${var.env}-grafana"
}

module "eks" {
  source      = "modules/AWS/EKS_module?ref=eks-v0.0.3"
  eks_version = "1.26"
  env         = "prod"
  eks_name    = "cluster"
  subnet_ids  = local.private_subnets
  node_groups = {
    general = {
      capacity_type  = "ON_DEMAND"
      instance_types = ["t3a.large"]
      scaling_config = {
        desired_size = 2
        max_size     = 3
        min_size     = 1
      }
    }
  }
}

output "asg" {
  value     = module.eks.asg
  sensitive = true
}
