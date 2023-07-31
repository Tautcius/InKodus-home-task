resource "helm_release" "grafana" {
  chart            = "grafana-operator"
  name             = "grafana-operator"
  repository       = "oci://ghcr.io/grafana-operator/helm-charts"
  create_namespace = true
  namespace        = var.namespace
  version          = var.chart_version
}
