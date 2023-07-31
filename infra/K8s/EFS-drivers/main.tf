data "aws_iam_openid_connect_provider" "this" {
  arn = var.openid_provider_arn
}

resource "aws_iam_policy" "aws_efs_csi_driver_policy" {
  name = "AmazonEKS_EFS_CSI_Driver_Policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "elasticfilesystem:DescribeAccessPoints",
          "elasticfilesystem:DescribeFileSystems",
          "elasticfilesystem:DescribeMountTargets",
          "ec2:DescribeAvailabilityZones"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "elasticfilesystem:CreateAccessPoint"
        ],
        "Resource" : "*",
        "Condition" : {
          "StringLike" : {
            "aws:RequestTag/efs.csi.aws.com/cluster" : "true"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : "elasticfilesystem:DeleteAccessPoint",
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "aws:ResourceTag/efs.csi.aws.com/cluster" : "true"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role" "aws_efs_csi_driver_role" {
  name               = "${var.eks_name}-efs-csi-driver-role"
  assume_role_policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Principal": {
                "Federated": "${data.aws_iam_openid_connect_provider.this.arn}"
            },
            "Condition": {
                "StringEquals": {
                    "${data.aws_iam_openid_connect_provider.this.url}:sub": "system:serviceaccount:kube-system:efs-csi-controller-sa"
                }
            }
        }
    ]
}
  EOF
}

resource "aws_iam_role_policy_attachment" "aws_efs_csi_driver_role" {
  role       = aws_iam_role.aws_efs_csi_driver_role.name
  policy_arn = aws_iam_policy.aws_efs_csi_driver_policy.arn
}

data "template_file" "efs_service_account" {
  template = file("${path.module}/sa.yaml")
  vars = {
    efs_arn = aws_iam_role.aws_efs_csi_driver_role.arn
  }
}

#galima be failo ^
resource "kubectl_manifest" "efs_service_account" {
  yaml_body         = data.template_file.efs_service_account.rendered
  server_side_apply = true
  depends_on = [
    aws_iam_policy.aws_efs_csi_driver_policy,
    aws_iam_role.aws_efs_csi_driver_role,
    aws_iam_role_policy_attachment.aws_efs_csi_driver_role
  ]
}
resource "helm_release" "aws-efs-csi-driver" {
  name       = "aws-efs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  chart      = "aws-efs-csi-driver"
  version    = var.efs_driver_helm_verion #2.4.1
  namespace  = "kube-system"

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.eu-central-1.amazonaws.com/eks/aws-efs-csi-driver"
  }
  set {
    name  = "controller.serviceAccount.create"
    value = "false"
  }
  set {
    name  = "controller.serviceAccount.name"
    value = "efs-csi-controller-sa"
  }

  depends_on = [
    aws_iam_role_policy_attachment.aws_efs_csi_driver_role,
    kubectl_manifest.efs_service_account
  ]
}
