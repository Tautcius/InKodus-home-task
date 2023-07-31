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

resource "aws_eks_addon" "aws-ebs-csi-driver" {
  cluster_name      = var.eks_name
  addon_name        = "aws-ebs-csi-driver"
  resolve_conflicts = "OVERWRITE"
  /* addon_version     = var.addon_coredns_version */
  depends_on = [
    data.aws_iam_role.nodes,
    data.aws_eks_cluster.this
  ]
}


data "aws_iam_policy_document" "aws_ebs_csi_driver_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      identifiers = [data.aws_iam_openid_connect_provider.this.arn]
      type        = "Federated"
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_iam_openid_connect_provider.this.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_iam_openid_connect_provider.this.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "aws_ebs_csi_driver_role" {
  name               = "${var.eks_name}-ebs-csi-driver-role"
  assume_role_policy = data.aws_iam_policy_document.aws_ebs_csi_driver_policy.json
}


resource "aws_iam_role_policy_attachment" "aws_ebs_csi_driver_role" {
  role       = aws_iam_role.aws_ebs_csi_driver_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}


resource "kubernetes_annotations" "ebs-csi-controller-sa" {
  api_version = "v1"
  kind        = "ServiceAccount"
  metadata {
    name      = "ebs-csi-controller-sa"
    namespace = "kube-system"
  }
  annotations = {
    "eks.amazonaws.com/role-arn" = aws_iam_role.aws_ebs_csi_driver_role.arn
  }
  depends_on = [ #dependina nuo addono eks
    aws_iam_role.aws_ebs_csi_driver_role,
    aws_eks_addon.aws-ebs-csi-driver
  ]
}
