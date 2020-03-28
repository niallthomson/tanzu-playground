locals {
  sys_domain = "cf.${var.domain}"
}

resource "random_password" "admin_password" {
  length = 16
  special = false
}

data "template_file" "values" {
  template = file("${path.module}/templates/values.yml")

  vars = {
    admin_password = random_password.admin_password.result
    domain       = local.sys_domain

    tls_cert     = base64encode(tls_locally_signed_cert.cf.cert_pem)
    tls_key     = base64encode(tls_private_key.cf.private_key_pem)
    tls_ca_cert     = base64encode(tls_self_signed_cert.acme_ca.cert_pem)
  }
}

data "k14s_ytt" "cf_for_k8s" {
  files = [
    "${var.ytt_lib_dir}/cf-for-k8s/vendor/github.com/cloudfoundry/cf-for-k8s/config",
    "${var.ytt_lib_dir}/cf-for-k8s/patch",
  ]

  config_yaml = data.template_file.values.rendered
}

resource "null_resource" "blocker" {
  provisioner "local-exec" {
    command = "echo 'Unblocked on ${var.blocker}'"
  }
}

resource "k14s_kapp" "cf_for_k8s" {
  depends_on = [null_resource.blocker]
  
  app = "cf"
  namespace = "default"

  config_yaml = data.k14s_ytt.cf_for_k8s.result
}