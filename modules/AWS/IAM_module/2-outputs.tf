output "role_arn" {
  value       = aws_iam_role.this.arn
  description = "Authentication role ARN."
}
output "account_id" {
  value = data.aws_caller_identity.this.account_id
}