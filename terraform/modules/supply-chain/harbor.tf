data "helm_repository" "harbor" {
  name = "harbor"
  url  = "https://helm.goharbor.io"
}

data "template_file" "harbor_cert" {
  depends_on = [
    null_resource.uaa_blocker,
    kubernetes_namespace.harbor,
  ]

  template = file("${path.module}/templates/harbor-cert.yml")

  vars = {
    harbor_domain = local.harbor_domain
    notary_domain = local.notary_domain
  }
}

module "harbor_cert" {
  source = "../apply"

  name = "harbor-cert"
  yaml = data.template_file.harbor_cert.rendered
}

resource "kubernetes_namespace" "harbor" {
  metadata {
    name = "harbor"
  }
}

data "template_file" "harbor_config" {
  template = file("${path.module}/templates/harbor-values.yml")

  vars = {
    harbor_domain = local.harbor_domain
    notary_domain = local.notary_domain
  }
}

resource "helm_release" "harbor" {
  depends_on = [null_resource.uaa_blocker]

  name       = "harbor"
  namespace  = kubernetes_namespace.harbor.metadata[0].name
  repository = data.helm_repository.harbor.name
  chart      = "harbor"
  version    = "1.3.1"

  values = [data.template_file.harbor_config.rendered]

  provisioner "local-exec" {
    command = "sleep 60"
  }
}

