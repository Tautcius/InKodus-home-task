variable "env" {
  description = "Environment name."
  type        = string
}
variable "rds_family" {
  description = "RDS family name."
  type        = string
}

variable "database_subnets" {
  description = "List of Database subnets ID's"
  type        = list(string)
}
variable "rds_engine" {
  description = "RDS engine"
  type        = string
}

variable "rds_engine_version" {
  description = "RDS engine version number"
  type        = string
}

variable "rds_instance_class" {
  description = "RDS instance class name"
  type        = string
}
variable "rds_storage_size" {
  description = "RDS instance class name"
  type        = number
  default     = 50
}

variable "rds_port" {
  description = "RDS port name"
  type        = number
  default     = 5432
}
variable "rds_db_name" {
  description = "RDS database name"
  type        = string
}
variable "rds_db_username" {
  description = "RDS database username name"
  type        = string
}
variable "rds_db_password" {
  description = "RDS database password"
  sensitive   = true
  type        = string
}
variable "manage_master_user_password" {
  description = "Enable to store master password in Secret Manager"
  type        = bool
  default     = false
}
variable "vpc_id" {
  description = "VPC id."
  type        = string
}

variable "eks_sg_id" {
  description = "EKS cluster primarty security group ID."
  type        = string
}
