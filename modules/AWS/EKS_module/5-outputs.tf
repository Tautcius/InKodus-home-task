output "eks_name" {
  value = aws_eks_cluster.this.name
}

output "openid_provider_arn" {
  value = aws_iam_openid_connect_provider.this[0].arn
}
output "eks_sg" {
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  description = "Security group Id of group from EKS to RDS"
}

output "asg" {
  value = values(aws_eks_node_group.this).*
}

output "eks_oidc_provider_url" {
  value       = aws_eks_cluster.this.identity[0].oidc[0].issuer
  description = "OICD provider url"
}
