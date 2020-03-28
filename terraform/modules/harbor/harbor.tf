data "helm_repository" "harbor" {
  name = "harbor"
  url  = "https://helm.goharbor.io"
}

resource "kubernetes_namespace" "harbor" {
  metadata {
    name = "harbor"
  }
}

data "template_file" "harbor_cert" {
  template = file("${path.module}/templates/cert.yml")

  vars = {
    harbor_domain = local.harbor_domain
    notary_domain = local.notary_domain
    namespace     = kubernetes_namespace.harbor.metadata[0].name
  }
}

resource "null_resource" "blocker" {
  provisioner "local-exec" {
    command = "echo ${var.blocker}"
  }
}

resource "k14s_kapp" "harbor_cert" {
  depends_on = [null_resource.blocker]
  app = "harbor-cert"
  
  namespace = "default"

  config_yaml = data.template_file.harbor_cert.rendered
}

resource "random_password" "admin_password" {
  length = 16
  special = false
}

data "template_file" "harbor_config" {
  template = file("${path.module}/templates/values.yml")

  vars = {
    harbor_domain  = local.harbor_domain
    notary_domain  = local.notary_domain
    admin_password = random_password.admin_password.result
  }
}

resource "helm_release" "harbor" {
  depends_on = [k14s_kapp.harbor_cert]

  name       = "harbor"
  namespace  = kubernetes_namespace.harbor.metadata[0].name
  repository = data.helm_repository.harbor.name
  chart      = "harbor"
  version    = "1.3.1"

  values = [data.template_file.harbor_config.rendered]

  timeout    = 400

  provisioner "local-exec" {
    command = "sleep 60"
  }
}

