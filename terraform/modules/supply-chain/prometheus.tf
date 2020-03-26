data "template_file" "prometheus_config" {
  template = file("${path.module}/templates/prometheus-values.yml")

  vars = {
    prometheus_domain = local.prometheus_domain
  }
}

resource "helm_release" "prometheus" {
  depends_on = [null_resource.uaa_blocker]

  name      = "prometheus"
  namespace = "prometheus"
  chart     = "stable/prometheus"
  version   = "11.0.2"

  values = [data.template_file.prometheus_config.rendered]

  provisioner "local-exec" {
    command = "sleep 60"
  }
}

resource "kubernetes_deployment" "prometheus_oauth_proxy" {
  depends_on = [helm_release.prometheus]

  metadata {
    name      = "oauth-proxy"
    namespace = "prometheus"

    labels = {
      app = "oauth-proxy"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "oauth-proxy"
      }
    }

    template {
      metadata {
        labels = {
          app = "oauth-proxy"
        }
      }

      spec {
        container {
          image             = "quay.io/pusher/oauth2_proxy:v3.2.0"
          image_pull_policy = "Always"
          name              = "proxy"

          port {
            container_port = 4180
          }

          env {
            name  = "OAUTH2_PROXY_PROVIDER"
            value = "oidc"
          }
          env {
            name  = "OAUTH2_PROXY_OIDC_ISSUER_URL"
            value = "https://${local.uaa_domain}:443/oauth/token"
          }
          env {
            name  = "OAUTH2_PROXY_REDIRECT_URL"
            value = "https://${local.prometheus_domain}/oauth2/callback"
          }
          env {
            name  = "OAUTH2_PROXY_CLIENT_ID"
            value = "prometheus-client"
          }
          env {
            name  = "OAUTH2_PROXY_CLIENT_SECRET"
            value = "abcd1234"
          }
          env {
            name  = "OAUTH2_PROXY_COOKIE_SECRET"
            value = "anyrandomstring"
          }
          env {
            name  = "OAUTH2_PROXY_HTTP_ADDRESS"
            value = "0.0.0.0:4180"
          }
          env {
            name  = "OAUTH2_PROXY_UPSTREAM"
            value = "https://${local.prometheus_domain}"
          }
          env {
            name  = "OAUTH2_PROXY_EMAIL_DOMAINS"
            value = "*"
          }
          env {
            name  = "OAUTH2_PROXY_SCOPE"
            value = "openid,roles,uaa.user"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "prometheus_oauth_proxy" {
  metadata {
    name      = "oauth-proxy"
    namespace = "prometheus"
  }

  spec {
    selector = {
      app = kubernetes_deployment.prometheus_oauth_proxy.metadata[0].name
    }
    port {
      port        = 4180
      target_port = 4180
      protocol    = "TCP"
      name        = "http"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_ingress" "prometheus_oauth_proxy" {
  metadata {
    name      = "oauth-proxy-ingress"
    namespace = "prometheus"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      host = local.prometheus_domain
      http {
        path {
          backend {
            service_name = kubernetes_service.prometheus_oauth_proxy.metadata[0].name
            service_port = 4180
          }

          path = "/oauth2"
        }
      }
    }

    tls {
      # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
      # force an interpolation expression to be interpreted as a list by wrapping it
      # in an extra set of list brackets. That form was supported for compatibility in
      # v0.11, but is no longer supported in Terraform v0.12.
      #
      # If the expression in the following list itself returns a list, remove the
      # brackets to avoid interpretation as a list of lists. If the expression
      # returns a single list item then leave it as-is and remove this TODO comment.
      hosts       = [local.prometheus_domain]
      secret_name = "oauth-proxy-tls-secret"
    }
  }
}

