terraform {
  cloud {
    organization = "Tagai"

    workspaces {
      name = "01-vpc"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.63.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.4.3"
    }

    local = {
      source  = "hashicorp/local"
      version = ">= 2.4.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn = var.role
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

