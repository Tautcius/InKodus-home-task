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

data "tfe_outputs" "vpc" {
  organization = "Tagai"
  workspace    = "01-vpc"
}

data "tfe_outputs" "eks" {
  organization = "Tagai"
  workspace    = "02-eks"
}

module "vpc-cni" {
  source              = "../../modules/K8s/VPC-cni"
  env                 = var.env
  eks_name            = local.eks_name
  openid_provider_arn = local.openid_provider_arn
  addon_vpc_cni       = true
}

module "kube-proxy" {
  source              = "../../modules/K8s/kube-proxy"
  env                 = var.env
  eks_name            = local.eks_name
  openid_provider_arn = local.openid_provider_arn
  addon_kube_proxy    = true
}

module "core-dns" {
  source              = "../../modules/K8s/core-dns"
  env                 = var.env
  eks_name            = local.eks_name
  openid_provider_arn = local.openid_provider_arn
  addon_coredns       = true
}

module "autoscaler" {
  source                         = "../../modules/K8s/Autoscaler"
  env                            = var.env
  eks_name                       = local.eks_name
  cluster_autoscaler_helm_verion = "9.29.1"
  openid_provider_arn            = local.openid_provider_arn
  depends_on = [
    module.kube-proxy,
    module.core-dns,
    module.vpc-cni
  ]
}

module "cert-manager" {
  source                          = "../../modules/K8s/Cert-manager"
  env                             = var.env
  eks_name                        = local.eks_name
  enable_issuer_cloudflare        = true
  cluster_certmanager_helm_verion = "1.12.3"
  openid_provider_arn             = local.openid_provider_arn
  cloudflare_api_token            = var.cloudflare_api_token
  email                           = "t.bujauskas@gmail.com"
  aws_region                      = "eu-north-1"
  depends_on = [
    module.autoscaler
  ]
}
module "traefik" {
  source              = "../../modules/K8s/Traefik"
  env                 = var.env
  eks_name            = local.eks_name
  openid_provider_arn = local.openid_provider_arn
  traefik_helm_verion = "23.2.0"
  traefik_values      = file("${path.module}/traefik/values.yaml")
  depends_on = [
    module.autoscaler,
    module.cert-manager
  ]
}
