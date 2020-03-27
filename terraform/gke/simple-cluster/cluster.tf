data "google_client_config" "current" {}

locals {
  full_environment_prefix = "tanzu-gke-simple-${var.environment_name}"
}

resource "google_container_cluster" "default" {
  name = local.full_environment_prefix
  location = var.zone
  initial_node_count = 3
  min_master_version = "1.15.9-gke.26"

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

  // Wait for the GCE LB controller to cleanup the resources.
  provisioner "local-exec" {
    when    = destroy
    command = "sleep 90"
  }
}