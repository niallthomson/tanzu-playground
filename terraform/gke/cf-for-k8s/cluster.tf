data "google_client_config" "current" {}

locals {
  full_environment_prefix = "tanzu-gke-cf-${var.environment_name}"
}

resource "google_container_cluster" "default" {
  name = local.full_environment_prefix
  location = var.zone
  initial_node_count = 5
  min_master_version = var.kubernetes_version

  node_config {
    image_type = "UBUNTU"
    machine_type = "n1-standard-2"

    metadata = {
      "disable-legacy-endpoints" = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/ndev.clouddns.readwrite",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  // Wait for cluster to stabilize
  provisioner "local-exec" {
    command = "sleep 60"
  }

  // Wait for the GCE LB controller to cleanup the resources.
  provisioner "local-exec" {
    when    = destroy
    command = "sleep 90"
  }
}

resource "null_resource" "cluster_blocker" {
  depends_on = [google_container_cluster.default]
}