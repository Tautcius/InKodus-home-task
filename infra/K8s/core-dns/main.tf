data "aws_iam_openid_connect_provider" "this" {
  arn = var.openid_provider_arn
}

data "aws_eks_cluster" "this" {
  name = var.eks_name
}

data "aws_iam_role" "nodes" {
  name = "${var.eks_name}-eks-nodes"
}

data "aws_iam_policy_document" "eks_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_iam_openid_connect_provider.this.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [data.aws_iam_openid_connect_provider.this.arn]
      type        = "Federated"
    }
  }
}

resource "aws_eks_addon" "coredns" {
  count = var.addon_coredns ? 1 : 0

  cluster_name      = var.eks_name
  addon_name        = "coredns"
  resolve_conflicts = "OVERWRITE"
  /* addon_version     = var.addon_coredns_version */
  depends_on = [
    data.aws_iam_role.nodes,
    data.aws_eks_cluster.this
  ]
}
