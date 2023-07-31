data "aws_iam_openid_connect_provider" "this" {
  arn = var.openid_provider_arn
}

resource "kubernetes_secret" "cloudflare_secret" {
  metadata {
    name      = "cloudflare-api-token-secret"
    namespace = "cert-manager"
  }
  type = "Opaque"
  data = {
    "api-token" = var.cloudflare_api_token
  }
  depends_on = [
    helm_release.cert-manager
  ]
}

resource "aws_iam_role" "cert_manager" {
  name               = "${var.eks_name}-cert-manager-role"
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
                    "${data.aws_iam_openid_connect_provider.this.url}:sub": "system:serviceaccount:cert-manager:cert-manager"
                }
            }
        }
    ]
}
  EOF
}

resource "aws_iam_role_policy" "cert_manager" {
  name = "${var.eks_name}-cert-manager-policy"
  role = aws_iam_role.cert_manager.id

  policy = <<-EOF
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": "route53:GetChange",
              "Resource": "arn:aws:route53:::change/*"
          },
          {
              "Effect": "Allow",
              "Action": [
                  "route53:ChangeResourceRecordSets",
                  "route53:ListResourceRecordSets"
              ],
              "Resource": "arn:aws:route53:::hostedzone/*"
          },
          {
              "Effect": "Allow",
              "Action": [
                "route53:ListHostedZonesByName",
                "route53:ListHostedZones"
                ],
              "Resource": "*"
          }
      ]
  }
  EOF
}

resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = var.cluster_certmanager_helm_verion
  namespace        = "cert-manager"
  create_namespace = true
  values = [
    templatefile("${path.module}/tmpl_values.yaml", {})
  ]
  set {
    name  = "serviceAccount.create"
    value = true
  }
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.cert_manager.arn
  }
  set {
    name  = "serviceAccount.name"
    value = "cert-manager"
  }
  set {
    name  = "installCRDs"
    value = true
  }
  # set {
  #   name  = "rbac.serviceAccount.name"
  #   value = "cert-manager"
  # }
  # set {
  #   name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
  #   value = aws_iam_role.cert-manager[0].arn
  # }
  set {
    name  = "autoDiscovery.clusterName"
    value = var.eks_name
  }
}

resource "kubectl_manifest" "issuer_clodflare" {
  count             = var.enable_issuer_cloudflare ? 1 : 0
  yaml_body         = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod-cloudflare
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: ${var.email}
    privateKeySecretRef:
      name: letsencrypt-private-key-cf
    solvers:
      # An empty 'selector' means that this solver matches all domains
      - selector: {}
        dns01:
          cloudflare:
            apiTokenSecretRef:
              name: cloudflare-api-token-secret
              key: api-token
YAML
  validate_schema   = false
  server_side_apply = true
  depends_on = [
    helm_release.cert-manager
  ]
}

resource "kubectl_manifest" "issuer_route53" {
  count             = var.enable_issuer_route53 ? 1 : 0
  yaml_body         = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: ${var.email}
    privateKeySecretRef:
      name: letsencrypt-private-key
    solvers:
      # An empty 'selector' means that this solver matches all domains
      - selector: {}
        dns01:
          route53:
            region: ${var.aws_region}
YAML
  validate_schema   = false
  server_side_apply = true
  depends_on = [
    helm_release.cert-manager
  ]
}
