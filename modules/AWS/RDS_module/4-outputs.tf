output "rds_sg_id" {
  description = "RDS security group ID."
  value       = aws_security_group.this.id
}
output "rds_address" {
  description = "hostname value for database"
  value       = aws_db_instance.this.address
}

output "rds_endpoint" {
  description = "endpoint value for database, address:port format"
  value       = aws_db_instance.this.endpoint
}

output "rds_port" {
  description = "port value for database"
  value       = aws_db_instance.this.port
}

output "rds_db_name" {
  description = "DB name"
  value       = aws_db_instance.this.db_name
}
