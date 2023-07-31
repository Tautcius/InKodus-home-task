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

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "subnets_private" {
  description = "private subnets"
  type        = list(string)

}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "eks_sg_id" {
  description = "eks security groups"
  type        = string
}
