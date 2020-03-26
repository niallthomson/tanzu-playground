resource "null_resource" "blocker" {
  provisioner "local-exec" {
    command = "echo 'unblocked on ${var.blocker}'"
  }
}

resource "kubernetes_config_map" "apply_config_map" {
  metadata {
    name = "apply-${var.name}"
    namespace = "kube-system"
  }

  data = {
    yml = "${var.yaml}"
  }
}

resource "kubernetes_job" "apply_job" {
  depends_on = [
    null_resource.blocker
  ]

  metadata {
    name = "apply-${var.name}"
    namespace = "kube-system"
  }

  spec {
    template {
      metadata {}

      spec {
        container {
          name    = "apply-${var.name}"
          image   = "lachlanevenson/k8s-kubectl:v1.13.10"
          command = ["kubectl", "apply", "-f", "/tmp/config/yml"]

          volume_mount {
            name = "yml"
            mount_path = "/tmp/config"
          }
        }

        volume {
          name = "yml"
          config_map {
            name = kubernetes_config_map.apply_config_map.metadata.0.name
          }
        }
        
        restart_policy = "Never"
        service_account_name = "helm"
        automount_service_account_token = true
      }
    }

    backoff_limit = 4
  }
}