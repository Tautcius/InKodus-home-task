data "aws_iam_policy_document" "grafana_service_test" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(local.eks_oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:test-grafana:grafana-sa"]
    }

    principals {
      identifiers = [local.openid_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "grafana_service_test" {

  assume_role_policy = data.aws_iam_policy_document.grafana_service.json
  name               = "grafana-role-test"
}

resource "aws_iam_policy" "grafana_service_test" {

  name = "grafana-assume-role-test"

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

resource "aws_iam_role_policy_attachment" "grafana_service_test" {
  role       = aws_iam_role.grafana_service_test.name
  policy_arn = aws_iam_policy.grafana_service_test.arn
}
