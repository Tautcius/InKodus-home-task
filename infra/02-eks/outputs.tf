output "eks_name" {
  value = module.eks.eks_name
}

output "openid_provider_arn" {
  value = module.eks.openid_provider_arn
}
output "eks_sg" {
  value = module.eks.eks_sg
}
output "eks_oidc_provider_url" {
  value = module.eks.eks_oidc_provider_url
}
