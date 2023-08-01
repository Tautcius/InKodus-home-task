data "aws_eks_cluster" "this" {
  name = var.eks_name
}

resource "helm_release" "awx_operator" {
  name             = "awx-operator-controller"
  repository       = "https://ansible.github.io/awx-operator"
  chart            = "awx-operator"
  namespace        = "awx-operator"
  version          = var.awx_operator_helm_verion #2.0.0
  create_namespace = true
  depends_on = [
    data.aws_eks_cluster.this
  ]
}
