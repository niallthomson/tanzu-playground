provider "google" {
  project = var.project
  region  = var.region

  version = "~> 3.14.0"
}

provider "kubernetes" {
  host                   = google_container_cluster.default.endpoint
  token                  = data.google_client_config.current.access_token
  client_certificate     = base64decode(google_container_cluster.default.master_auth.0.client_certificate)
  client_key             = base64decode(google_container_cluster.default.master_auth.0.client_key)
  cluster_ca_certificate = base64decode(google_container_cluster.default.master_auth.0.cluster_ca_certificate)
  load_config_file = false
}

provider "helm" {
  kubernetes {
    host                   = "https://${google_container_cluster.default.endpoint}"
    token                  = data.google_client_config.current.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.default.master_auth.0.cluster_ca_certificate)
    load_config_file       = false
  }

  version = "~> 1.1.0"
}

provider "k14sx" {
  kapp {
    kubernetes {
      host                   = google_container_cluster.default.endpoint
      token                  = data.google_client_config.current.access_token
      cluster_ca_certificate = base64decode(google_container_cluster.default.master_auth.0.cluster_ca_certificate)
      load_config_file       = false
    }
  }

  version = "~> 0.0.2"
}

locals {
  ytt_lib_dir = "${path.module}/../../../ytt-libs"
}