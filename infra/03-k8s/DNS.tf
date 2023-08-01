data "cloudflare_zones" "domain" {
  filter {
    name = var.domain
  }
}


data "kubernetes_service" "nginx_ingress" {
  metadata {
    name      = "nginx-ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
}

locals {
  hostname = data.kubernetes_service.nginx_ingress.status.0.load_balancer.0.ingress.0.hostname
}


output "loadbalancer" {
  value = local.hostname
}
resource "cloudflare_record" "domain_star" {
  name    = "*"
  value   = local.hostname
  type    = "CNAME"
  zone_id = data.cloudflare_zones.domain.zones[0].id
  ttl     = 1
  proxied = true
}
