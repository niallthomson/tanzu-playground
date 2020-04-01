resource "kubernetes_namespace" "certmanager" {
  metadata {
    name = "certmanager"
  }
}

resource "null_resource" "in_blocker" {
  provisioner "local-exec" {
    command = "echo 'Unblocked on ${var.blocker}'"
  }
}

data "template_file" "prereqs" {
  template = file("${path.module}/templates/prereqs.yml")

  vars = {
    accessKey              = aws_iam_access_key.key.id
    region                 = var.region
    acmeEmail              = var.acme_email
    hostedZoneId           = var.hosted_zone_id
    domain                 = var.domain
    namespace              = kubernetes_namespace.certmanager.metadata[0].name
    encodedAccessKey       = base64encode(aws_iam_access_key.key.id)
    encodedSecretAccessKey = base64encode(aws_iam_access_key.key.secret)
  }
}

resource "k14sx_kapp" "prereqs" {
  depends_on = [null_resource.in_blocker]

  app = "certmanager-prereqs"
  namespace = "default"

  files = [
    "https://raw.githubusercontent.com/jetstack/cert-manager/release-0.13/deploy/manifests/00-crds.yaml"
  ]

  config_yaml = data.template_file.prereqs.rendered
}

data "helm_repository" "jetstack" {
  name = "jetstack"
  url  = "https://charts.jetstack.io"
}

resource "helm_release" "certmanager" {
  depends_on = [k14sx_kapp.prereqs]

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
    value = "route53"
  }

  provisioner "local-exec" {
    command = "sleep 30"
  }
}

resource "null_resource" "out_blocker" {
  depends_on = [helm_release.certmanager]
}