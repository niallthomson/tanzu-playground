data "k14s_ytt" "externaldns" {
  files = [
    //"https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.6/docs/examples/external-dns.yaml",
    "${var.ytt_lib_dir}/external-dns"
  ]

  values = merge({
    namespace = var.namespace
    domainFilter = var.domain_filter
    provider = var.dns_provider
    zoneIdFilter = var.zone_id_filter
    enableIstio = var.enable_istio
  }, var.values)

  ignore_unknown_comments = true
}

resource "null_resource" "in_blocker" {
  provisioner "local-exec" {
    command = "echo 'Unblocked on ${var.blocker}'"
  }
}

resource "k14s_kapp" "externaldns" {
  depends_on = [null_resource.in_blocker]

  app = "externaldns"
  namespace = "default"

  config_yaml = data.k14s_ytt.externaldns.result

  // Sleep before destroying so external-dns has time to clean up records
  provisioner "local-exec" {
    when    = destroy
    command = "sleep 90"
  }
}

resource "null_resource" "out_blocker" {
  depends_on = [k14s_kapp.externaldns]
}