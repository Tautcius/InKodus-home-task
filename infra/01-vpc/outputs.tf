output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC id"
}

output "vpc_private_subnets" {
  value       = module.vpc.private_subnets
  description = "List of IDs of private subnets"
}

output "vpc_public_subnets" {
  value       = module.vpc.public_subnets
  description = "List of IDs of public subnets"
}

output "vpc_database_subnets" {
  value       = module.vpc.database_subnets
  description = "list of IDs of database subnets"
}
