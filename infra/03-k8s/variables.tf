variable "env" {
  description = "Enviroment tag"
  type        = string
}

variable "ownership" {
  description = "Infrastructure is created by Tagai"
  default     = "Skaylink"
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

variable "role_arn" {
  description = "AWS IAM role"
  type        = string
}

variable "username_oci" {
  description = "oci username"
  type        = string
}

variable "password_oci" {
  description = "oci password"
  type        = string
}
variable "rds_master_username" {
  description = "DB master username"
  type        = string
}
variable "rds_master_password" {
  description = "DB master password"
  type        = string
  sensitive   = true
}
