data "helm_repository" "default" {
  name = "eirini"
  url  = "https://cloudfoundry-incubator.github.io/eirini-release"
}

resource "random_string" "uaa_admin_client_secret" {
  length  = 24
  special = false
}

data "template_file" "helm_config" {
  template = file("${path.module}/templates/uaa-values.yml")
  vars = {
    DOMAIN                  = var.domain_suffix
    UAA_ADMIN_CLIENT_SECRET = random_string.uaa_admin_client_secret.result
  }
}

resource "helm_release" "uaa" {
  depends_on = [null_resource.infra_blocker]

  name       = "uaa"
  namespace  = "uaa"
  repository = data.helm_repository.default.name
  chart      = "uaa"
  version    = "2.19.1"
  values     = [data.template_file.helm_config.rendered]
  wait       = true
  timeout    = 600

  # wait for the load balancer ips to exist
  # wait for the load balancer ips to exist
  provisioner "local-exec" {
    command = "sleep 120"
  }
}

data "template_file" "uaa_users_script" {
  template = file("${path.module}/templates/uaa-users.sh")

  vars = {
    uaa_url               = "https://${local.uaa_domain}:443"
    uaa_client_id         = "admin"
    uaa_client_secret     = random_string.uaa_admin_client_secret.result
    concourse_domain      = local.concourse_domain
    harbor_domain         = local.harbor_domain
    prometheus_domain     = local.prometheus_domain
    grafana_domain        = local.grafana_domain
    spinnaker_gate_domain = local.spinnaker_gate_domain
    secret                = "abcd1234"
    username              = var.uaa_username
    password              = var.uaa_password
  }
}

resource "kubernetes_config_map" "uaa_users_config_map" {
  depends_on = [helm_release.uaa]

  metadata {
    name      = "uaa-users-config"
    namespace = "kube-system"
  }

  data = {
    users = data.template_file.uaa_users_script.rendered
  }
}

resource "kubernetes_job" "uaa_users_job" {
  depends_on = [helm_release.uaa]

  metadata {
    name      = "uaa-users-job"
    namespace = "kube-system"
  }

  spec {
    template {
      metadata {
      }

      spec {
        container {
          name    = "uaa-users"
          image   = "nthomsonpivotal/cf-uaac"
          command = ["bash", "/tmp/config/users"]

          volume_mount {
            name       = "script"
            mount_path = "/tmp/config"
          }
        }

        volume {
          name = "script"
          config_map {
            name = kubernetes_config_map.uaa_users_config_map.metadata[0].name
          }
        }

        restart_policy = "Never"

        service_account_name            = "helm"
        automount_service_account_token = true
      }
    }

    backoff_limit = 4
  }
}

resource "null_resource" "uaa_blocker" {
  depends_on = [kubernetes_job.uaa_users_job]
}

