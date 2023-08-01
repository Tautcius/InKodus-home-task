
output "role_arn" {
  value       = module.iam.role_arn
  description = "Authentication role ARN."
}
