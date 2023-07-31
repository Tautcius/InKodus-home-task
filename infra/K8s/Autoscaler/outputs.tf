output "eks_cluster_autoscaler_arn" {
  value = aws_iam_role.cluster_autoscaler.arn
}
