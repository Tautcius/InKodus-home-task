terraform {
  cloud {
    organization = "Tagai"

    workspaces {
      name = "00-iam"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.63.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Environment = var.env
      Terraform   = "true"
      CreatedBy   = var.ownership
      Project     = "Grafana"
    }
  }
}

