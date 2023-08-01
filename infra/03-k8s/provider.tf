terraform {
  cloud {
    organization = "Tagai"

    workspaces {
      name = "03-k8s"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.62.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 3.32.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.19.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}


provider "aws" {
  region = var.aws_region
  /* profile = "BTT-service" */
  assume_role {
    role_arn     = var.role
    session_name = "Terraform_remote"
  }
  default_tags {
    tags = {
      Environment = var.env
      Terraform   = "true"
      CreatedBy   = var.ownership
      Project     = "InKodus"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
data "aws_eks_cluster" "default" {
  name = local.eks_name
}

data "aws_eks_cluster_auth" "default" {
  name = local.eks_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.default.token
}
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.default.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.default.token
  }
  # registry {
  #   url      = "oci://ghcr.io"
  #   username = var.username_oci
  #   password = var.password_oci
  # }
}
provider "kubectl" {
  apply_retry_count      = 15
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.default.token
  load_config_file       = false
}
# provider "postgresql" {
#   host            = local.rds_address
#   port            = local.rds_port
#   database        = local.rds_db_name
#   username        = var.rds_master_username
#   password        = var.rds_master_password
#   sslmode         = "require"
#   connect_timeout = 15
# }
