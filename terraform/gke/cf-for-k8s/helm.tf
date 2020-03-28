provider "helm" {
  kubernetes {
    host     = "https://${google_container_cluster.default.endpoint}"
    token    = data.google_client_config.current.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.default.master_auth.0.cluster_ca_certificate)
  }

  load_config_file       = false

  version = "~> 1.1.0"
}