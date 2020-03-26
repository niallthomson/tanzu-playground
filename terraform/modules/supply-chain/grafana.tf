data "template_file" "grafana_config" {
  template = file("${path.module}/templates/grafana-values.yml")

  vars = {
    grafana_domain = local.grafana_domain
    uaa_domain     = local.uaa_domain
  }
}

resource "helm_release" "grafana" {
  depends_on = [null_resource.uaa_blocker]

  name      = "grafana"
  namespace = "grafana"
  chart     = "stable/grafana"
  version   = "5.0.5"

  values = [data.template_file.grafana_config.rendered]
}

