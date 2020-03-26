data "k14s_ytt" "nginx" {
  files = ["${var.ytt_lib_dir}/nginx-ingress"]

  values = {
    "nginx.namespace" = var.namespace
  }
}

resource "null_resource" "blocker" {
  provisioner "local-exec" {
    command = "echo 'Unblocked on ${var.blocker}'"
  }
}

resource "k14s_app" "nginx" {
  depends_on = [null_resource.blocker]
  
  name = "nginx-ingress"
  namespace = "default"

  yaml = data.k14s_ytt.nginx.result
}