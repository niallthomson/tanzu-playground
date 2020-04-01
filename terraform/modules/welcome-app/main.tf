data "k14sx_ytt" "welcome_app" {
  files = ["${var.ytt_lib_dir}/welcome-app"]

  values = {
    namespace = var.namespace,
    ingressDomain = "welcome-app.${var.base_domain}",
  }
}

resource "null_resource" "blocker" {
  provisioner "local-exec" {
    command = "echo 'Unblocked on ${var.blocker}'"
  }
}

resource "k14sx_kapp" "welcome_app" {
  depends_on = [null_resource.blocker]
  
  app = "welcome-app"
  namespace = "default"

  config_yaml = data.k14sx_ytt.welcome_app.result
}