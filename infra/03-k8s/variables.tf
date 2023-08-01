variable "env" {
  description = "Enviroment tag"
  type        = string
}

variable "ownership" {
  description = "Infrastructure is created by Tagai"
  default     = "Tagai"
  type        = string
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  sensitive   = true
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "role" {
  description = "AWS IAM role"
  type        = string
}

variable "domain" {
  description = "Cloudflare Domain"
  type        = string
}
