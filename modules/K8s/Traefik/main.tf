data "aws_eks_cluster" "this" {
  name = var.eks_name
}

resource "helm_release" "traefik" {
  name             = "traefik"
  repository       = "https://traefik.github.io/charts"
  chart            = "traefik"
  version          = var.nginx_ingress_helm_verion #23.2.0
  namespace        = "traefik"
  create_namespace = true
  values = [
    var.nginx_values
  ]
  depends_on = [
    data.aws_eks_cluster.this
  ]
}
