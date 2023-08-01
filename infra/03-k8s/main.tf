locals {
  eks_name = data.tfe_outputs.eks.values.eks_name
  eks_sg   = data.tfe_outputs.eks.values.eks_sg
  # eks_cluster_id      = data.tfe_outputs.eks.values.eks_cluster_id
  eks_oidc_provider_url = data.tfe_outputs.eks.values.eks_oidc_provider_url
  openid_provider_arn   = data.tfe_outputs.eks.values.openid_provider_arn
  vpc_private_subnets   = data.tfe_outputs.vpc.values.vpc_private_subnets
  vpc_id                = data.tfe_outputs.vpc.values.vpc_id
  # rds_address         = data.tfe_outputs.rds.values.rds_address
  # rds_port            = data.tfe_outputs.rds.values.rds_port
  # rds_endpoint        = data.tfe_outputs.rds.values.rds_endpoint
  # rds_db_name         = data.tfe_outputs.rds.values.rds_db_name
}
# 04 folder, kur yra values failas nginx values paduot i var, kuris to tikisi
data "tfe_outputs" "vpc" {
  organization = "Tagai"
  workspace    = "01-vpc-${var.env}-grafana"
}

data "tfe_outputs" "eks" {
  organization = "Tagai"
  workspace    = "02-eks-${var.env}-grafana"
}
data "tfe_outputs" "rds" {
  organization = "Tagai"
  workspace    = "03-rds-${var.env}-grafana"
}
module "vpc-cni" {
  source              = "git::git@ssh.dev.azure.com:v3/BTT-Devops/BTT%20Group/aws-terraform-modules//K8s/VPC-cni?ref=vpc-cni-v0.0.1"
  env                 = var.env
  eks_name            = local.eks_name
  openid_provider_arn = local.openid_provider_arn
  addon_vpc_cni       = true
}

module "kube-proxy" {
  source              = "git::git@ssh.dev.azure.com:v3/BTT-Devops/BTT%20Group/aws-terraform-modules//K8s/kube-proxy?ref=kube-proxy-v0.0.1"
  env                 = var.env
  eks_name            = local.eks_name
  openid_provider_arn = local.openid_provider_arn
  addon_kube_proxy    = true
}

module "core-dns" {
  source              = "git::git@ssh.dev.azure.com:v3/BTT-Devops/BTT%20Group/aws-terraform-modules//K8s/core-dns?ref=core-dns-v0.0.1"
  env                 = var.env
  eks_name            = local.eks_name
  openid_provider_arn = local.openid_provider_arn
  addon_coredns       = true
}

module "autoscaler" {
  source                         = "git::git@ssh.dev.azure.com:v3/BTT-Devops/BTT%20Group/aws-terraform-modules//K8s/Autoscaler?ref=autoscaler-v0.0.5"
  env                            = var.env
  eks_name                       = local.eks_name
  cluster_autoscaler_helm_verion = "9.28.0"
  openid_provider_arn            = local.openid_provider_arn
  depends_on = [
    module.kube-proxy,
    module.core-dns,
    module.vpc-cni
  ]
}

module "cert-manager" {
  source                          = "git::git@ssh.dev.azure.com:v3/BTT-Devops/BTT%20Group/aws-terraform-modules//K8s/Cert-manager?ref=cert-manager-v0.0.5"
  env                             = var.env
  eks_name                        = local.eks_name
  enable_issuer_cloudflare        = true
  cluster_certmanager_helm_verion = "1.11.1"
  openid_provider_arn             = local.openid_provider_arn
  cloudflare_api_token            = var.cloudflare_api_token
  email                           = "t.bujauskas@gmail.com"
  aws_region                      = "eu-central-1"
  depends_on = [
    module.autoscaler
  ]
}

# module "alb-ingress-controller" {
#   source              = "git::git@ssh.dev.azure.com:v3/BTT-Devops/BTT%20Group/aws-terraform-modules//K8s/ALB-ingress-controller?ref=alb-v0.0.4"
#   env                 = var.env_tag
#   eks_name            = local.eks_name
#   alb_helm_verion     = "1.5.1"
#   openid_provider_arn = local.openid_provider_arn
#   depends_on = [
#     module.autoscaler
#   ]
# }

module "ebs-driver" {
  source              = "git::git@ssh.dev.azure.com:v3/BTT-Devops/BTT%20Group/aws-terraform-modules//K8s/EBS-driver?ref=ebs-drivers-v0.0.3"
  env                 = var.env
  eks_name            = local.eks_name
  openid_provider_arn = local.openid_provider_arn
  depends_on = [
    module.autoscaler
  ]
}

module "efs-driver" {
  source                 = "git::git@ssh.dev.azure.com:v3/BTT-Devops/BTT%20Group/aws-terraform-modules//K8s/EFS-drivers?ref=efs-drivers-v0.0.5"
  env                    = var.env
  eks_name               = local.eks_name
  openid_provider_arn    = local.openid_provider_arn
  efs_driver_helm_verion = "2.4.1"
  depends_on = [
    module.autoscaler
  ]
}

module "efs" {
  source              = "modules/AWS/EFS?ref=efs-v0.0.1"
  env                 = var.env
  eks_name            = local.eks_name
  openid_provider_arn = local.openid_provider_arn
  eks_sg_id           = local.eks_sg
  subnets_private     = local.vpc_private_subnets
  vpc_id              = local.vpc_id
  depends_on = [
    module.efs-driver,
    module.autoscaler
  ]
}

module "awx-operator" {
  source                   = "git::git@ssh.dev.azure.com:v3/BTT-Devops/BTT%20Group/aws-terraform-modules//K8s/AWX-operator?ref=awx-operator-v0.0.1"
  env                      = var.env
  eks_name                 = local.eks_name
  awx_operator_helm_verion = "2.0.0"
  openid_provider_arn      = local.openid_provider_arn
  depends_on = [
    module.autoscaler
  ]
}

module "grafana-operator" {
  source = "git::git@ssh.dev.azure.com:v3/BTT-Devops/BTT%20Group/aws-terraform-modules//K8s/Grafana-operator?ref=grafana-operator-v0.0.16"
  depends_on = [
    module.autoscaler
  ]
}

module "nginx-controller" {
  source = "git::git@ssh.dev.azure.com:v3/BTT-Devops/BTT%20Group/aws-terraform-modules//K8s/Nginx-ingress-controller?ref=nginx-v0.0.4"
  #  source                    = "../Nginx-ingress-controller"
  env                       = var.env
  eks_name                  = local.eks_name
  openid_provider_arn       = local.openid_provider_arn
  nginx_ingress_helm_verion = "4.6.0"
  nginx_values              = file("${path.module}/nginx/values.yaml")
  depends_on = [
    module.autoscaler
  ]
}
