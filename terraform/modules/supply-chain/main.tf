locals {
  uaa_domain            = "uaa.${var.domain_suffix}"
  harbor_domain         = "harbor.${var.domain_suffix}"
  notary_domain         = "notary.${var.domain_suffix}"
  concourse_domain      = "concourse.${var.domain_suffix}"
  prometheus_domain     = "prometheus.${var.domain_suffix}"
  grafana_domain        = "grafana.${var.domain_suffix}"
  spinnaker_domain      = "spinnaker.${var.domain_suffix}"
  spinnaker_gate_domain = "gate.spinnaker.${var.domain_suffix}"
  kpack_viz_domain      = "kpack.${var.domain_suffix}"
}

resource "null_resource" "infra_blocker" {
  provisioner "local-exec" {
    command = "echo ${var.blocker}"
  }
}

