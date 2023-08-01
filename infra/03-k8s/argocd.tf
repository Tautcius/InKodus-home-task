
# module "argocd" {
#   source        = "squareops/argocd/kubernetes"
#   version       = "1.0.0"
#   chart_version = "5.42.1"
#   namespace     = "argocd"
#   argocd_config = {
#     hostname                     = "argocd.tagai.uk"
#     values_yaml                  = file("./argocd/values.yaml")
#     redis_ha_enabled             = false
#     autoscaling_enabled          = false
#     slack_notification_token     = "xoxb-qQ8486bluEuvmxrYx"
#     argocd_notifications_enabled = false
#   }
# }
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.42.1"
  namespace        = "argocd"
  create_namespace = true
  values = [
    file("${path.module}/argocd/values.yaml")
  ]
}
