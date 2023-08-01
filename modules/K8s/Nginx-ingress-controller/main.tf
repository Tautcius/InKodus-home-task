data "aws_eks_cluster" "this" {
  name = var.eks_name
}

resource "helm_release" "nginx" {
  name             = "nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = var.nginx_ingress_helm_verion #4.6.0
  namespace        = "ingress-nginx"
  create_namespace = true
  values = [
    var.nginx_values
  ]
  depends_on = [
    data.aws_eks_cluster.this
  ]
}
