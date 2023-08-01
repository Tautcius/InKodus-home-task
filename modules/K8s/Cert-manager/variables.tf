variable "env" {
  description = "Environment name."
  type        = string
}

variable "eks_name" {
  description = "Name of the cluster."
  type        = string
}

variable "openid_provider_arn" {
  description = "IAM Openid Connect Provider ARN"
  type        = string
}

variable "enable_issuer_cloudflare" {
  description = "Determines whether to create issuer for cloudflare"
  type        = bool
  default     = false
}

variable "enable_issuer_route53" {
  description = "Determines whether to create issuer for route53"
  type        = bool
  default     = false
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  sensitive   = true
  type        = string
}

variable "email" {
  description = "email address for certificates"
  type        = string
}

variable "cluster_certmanager_helm_verion" {
  description = "helm version for cert-manager"
  type        = string
}
