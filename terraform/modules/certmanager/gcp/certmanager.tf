resource "kubernetes_namespace" "certmanager" {
  metadata {
    name = "certmanager"
  }
}

resource "kubernetes_job" "certmanager_prereq" {
  depends_on = [kubernetes_namespace.certmanager]

  metadata {
    name      = "certmanager-prereq"
    namespace = "kube-system"
  }

  spec {
    template {
      metadata {
      }
      spec {
        container {
          name    = "run"
          image   = "bitnami/kubectl"
          command = ["kubectl", "apply", "--validate=false", "-f", "https://raw.githubusercontent.com/jetstack/cert-manager/release-0.13/deploy/manifests/00-crds.yaml"]
        }

        restart_policy                  = "Never"
        service_account_name            = var.apply_service_account_name
        automount_service_account_token = true
      }
    }
    backoff_limit = 4
  }

  provisioner "local-exec" {
    command = "sleep 30"
  }
}

data "template_file" "issuers" {
  template = file("${path.module}/templates/issuer.yml")

  vars = {
    project      = var.project
    acmeEmail    = var.acme_email
    domain       = var.domain
  }
}

resource "kubernetes_config_map" "issuer_config_map" {
  metadata {
    name      = "issuer-map"
    namespace = "kube-system"
  }

  data = {
    "issuer.yml" = data.template_file.issuers.rendered
  }
}

resource "kubernetes_job" "certmanager_issuer" {
  depends_on = [
    kubernetes_job.certmanager_prereq,
  ]

  metadata {
    name      = "certmanager-issuer"
    namespace = "kube-system"
  }
  spec {
    template {
      metadata {
      }
      spec {
        container {
          name    = "run"
          image   = "bitnami/kubectl"
          command = ["kubectl", "apply", "--validate=false", "-f", "/var/issuer/issuer.yml"]

          volume_mount {
            mount_path = "/var/issuer"
            name       = "issuer"
          }
        }

        volume {
          name = "issuer"
          config_map {
            name = kubernetes_config_map.issuer_config_map.metadata[0].name
          }
        }

        restart_policy                  = "Never"
        service_account_name            = var.apply_service_account_name
        automount_service_account_token = true
      }
    }
    backoff_limit = 4
  }
}

data "helm_repository" "jetstack" {
  name = "jetstack"
  url  = "https://charts.jetstack.io"
}

resource "helm_release" "certmanager" {
  depends_on = [kubernetes_job.certmanager_prereq]

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

