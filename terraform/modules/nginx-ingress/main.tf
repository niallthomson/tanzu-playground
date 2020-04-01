data "k14sx_ytt" "nginx" {
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

resource "k14sx_kapp" "nginx" {
  depends_on = [null_resource.blocker]
  
  app = "nginx-ingress"
  namespace = "default"

  config_yaml = data.k14sx_ytt.nginx.result
}