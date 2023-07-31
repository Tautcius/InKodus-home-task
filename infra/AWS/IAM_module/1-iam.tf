data "aws_caller_identity" "this" {}

data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.env}_terraform_role"
  description        = "Role to be assumed for creating infrastructure in ${var.env} enviroment."
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_iam_policy_document" "this" {
  version = "2012-10-17"

  statement {
    sid       = "AllowAssumeRole"
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = [aws_iam_role.this.arn]
  }
}

resource "aws_iam_policy" "this" {
  name        = "Allow_assume_terraform_role_${var.env}"
  description = "Allow useres in group to assume role."
  policy      = data.aws_iam_policy_document.this.json
}

resource "aws_iam_group" "this" {
  name = "Terraform_admins_${var.env}"
}

resource "aws_iam_group_policy_attachment" "this" {
  group      = aws_iam_group.this.name
  policy_arn = aws_iam_policy.this.arn
}
