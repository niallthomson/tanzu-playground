locals {
  sys_domain = "cf.${var.domain}"
}

data "template_file" "values" {
  template = file("${path.module}/templates/values.yml")

  vars = {
    domain       = local.sys_domain
  }
}

data "k14s_ytt" "cf_for_k8s" {
  files = [
    "${var.ytt_lib_dir}/cf-for-k8s/vendor/github.com/cloudfoundry/cf-for-k8s/config",
    "${var.ytt_lib_dir}/cf-for-k8s/patch",
  ]

  yaml = data.template_file.values.rendered
}

resource "null_resource" "blocker" {
  provisioner "local-exec" {
    command = "echo 'Unblocked on ${var.blocker}'"
  }
}

resource "k14s_app" "externaldns" {
  depends_on = [null_resource.blocker]
  
  name = "cf"
  namespace = "default"

  yaml = data.k14s_ytt.cf_for_k8s.result
}

resource "local_file" "test" {
  content  = data.k14s_ytt.cf_for_k8s.result
  
  filename = "${path.module}/test.yml"
}