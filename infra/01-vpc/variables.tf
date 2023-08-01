variable "vpc_cird" {
  description = "VPC cird range"
  type        = string
}
variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "ownership" {
  description = "Infrastructure is created by Tagai"
  default     = "Tagai"
  type        = string
}
variable "env" {
  description = "Enviroment tag"
  type        = string
}

variable "role" {
  description = "Role to assume"
  type        = string
}
