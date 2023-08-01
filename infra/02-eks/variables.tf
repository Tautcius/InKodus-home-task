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
  default     = "Skaylink"
  type        = string
}

# variable "domain" {
#   description = "Domain name for SSL certificate."
#   type        = string
#   default     = "test.lt"
# }
