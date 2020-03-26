data "k14s_ytt" "externaldns" {
  files = [
    "https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.6/docs/examples/external-dns.yaml",
    "${var.ytt_lib_dir}/external-dns"
  ]

  values = merge({
    namespace = var.namespace
    domainFilter = var.domain_filter
    provider = var.dns_provider
    zoneIdFilter = var.zone_id_filter
  }, var.values)
}

resource "null_resource" "blocker" {
  provisioner "local-exec" {
    command = "echo 'Unblocked on ${var.blocker}'"
  }
}

resource "k14s_app" "externaldns" {
  depends_on = [null_resource.blocker]
  
  name = "externaldns"
  namespace = "default"

  yaml = data.k14s_ytt.externaldns.result
}