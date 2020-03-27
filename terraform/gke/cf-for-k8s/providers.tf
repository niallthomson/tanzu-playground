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

provider "k14s" {
  kubeconfig_yml = data.template_file.kubeconfig.rendered
}