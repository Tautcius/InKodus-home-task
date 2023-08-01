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

# variable "domain" {
#   description = "Domain name for SSL certificate."
#   type        = string
#   default     = "test.lt"
# }

variable "role" {
  description = "Role to assume"
  type        = string
}
