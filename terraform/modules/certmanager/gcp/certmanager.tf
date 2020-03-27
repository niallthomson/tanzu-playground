resource "kubernetes_namespace" "certmanager" {
  metadata {
    name = "certmanager"
  }
}

data "template_file" "issuers" {
  template = file("${path.module}/templates/issuer.yml")

  vars = {
    project      = var.project
    acmeEmail    = var.acme_email
    domain       = var.domain
    namespace    = kubernetes_namespace.certmanager.metadata[0].name
  }
}

resource "k14s_kapp" "pre_reqs" {
  app = "nginx-ingress"
  //app = "cert-manager-prereqs"
  
  namespace = "default"

  files = [
    "https://raw.githubusercontent.com/jetstack/cert-manager/release-0.13/deploy/manifests/00-crds.yaml"
  ]

  config_yaml = data.template_file.issuers.rendered
}

data "helm_repository" "jetstack" {
  name = "jetstack"
  url  = "https://charts.jetstack.io"
}

resource "helm_release" "certmanager" {
  depends_on = [k14s_kapp.pre_reqs]

  name       = "certmanager"
  namespace  = kubernetes_namespace.certmanager.metadata[0].name
  repository = data.helm_repository.jetstack.name
  chart      = "cert-manager"
  version    = "v0.13.0"

  set {
    name  = "ingressShim.defaultIssuerName"
    value = "letsencrypt-prod"
  }

  set {
    name  = "ingressShim.defaultIssuerKind"
    value = "ClusterIssuer"
  }

  set {
    name  = "ingressShim.defaultACMEChallengeType"
    value = "dns01"
  }

  set {
    name  = "ingressShim.defaultACMEDNS01ChallengeProvider"
    value = "clouddns"
  }

  provisioner "local-exec" {
    command = "sleep 30"
  }
}

