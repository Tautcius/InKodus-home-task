data "aws_iam_policy_document" "grafana_service" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(local.eks_oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:grafana:grafana-sa"]
    }

    principals {
      identifiers = [local.openid_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "grafana_service" {

  assume_role_policy = data.aws_iam_policy_document.grafana_service.json
  name               = "grafana-role-${var.env}"
}

resource "aws_iam_policy" "grafana_service" {

  name = "grafana-assume-role-${var.env}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "Initial",
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "grafana_service" {
  role       = aws_iam_role.grafana_service.name
  policy_arn = aws_iam_policy.grafana_service.arn
}
