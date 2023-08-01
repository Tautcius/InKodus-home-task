variable "env" {
  description = "Enviroment tag"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "ownership" {
  description = "Infrastructure is created by Tagai"
  default     = "Tagai"
  type        = string
}
