variable "namespace" {
  description = "Namespace for grafana-operator"
  default     = "grafana-operator"
  type        = string
}
variable "chart_version" {
  description = "Grafana-operator version"
  default     = "v5.0.0-rc2"
  type        = string
}
