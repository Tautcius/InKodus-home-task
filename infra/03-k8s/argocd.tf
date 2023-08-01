
module "argocd" {
  source        = "squareops/argocd/kubernetes"
  version       = "1.0.0"
  chart_version = "5.42.1"
  namespace     = "argocd"
  argocd_config = {
    hostname                     = "argocd.tagai.uk"
    values_yaml                  = file("${path.module}/argocd/values.yaml")
    redis_ha_enabled             = false
    autoscaling_enabled          = false
    slack_notification_token     = "xoxb-qQ8486bluEuvmxrYx"
    argocd_notifications_enabled = false
  }
}
