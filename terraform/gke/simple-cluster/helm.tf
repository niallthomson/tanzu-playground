module "helm" {
  source = "../../modules/helm"

  blocker = google_container_cluster.default.endpoint
}

provider "helm" {
  install_tiller = true
  tiller_image = "gcr.io/kubernetes-helm/tiller:v2.13.1"
  service_account = module.helm.service_account_name

  kubernetes {
    host                   = google_container_cluster.default.endpoint
    token                  = data.google_client_config.current.access_token
    client_certificate     = base64decode(google_container_cluster.default.master_auth.0.client_certificate)
    client_key             = base64decode(google_container_cluster.default.master_auth.0.client_key)
    cluster_ca_certificate = base64decode(google_container_cluster.default.master_auth.0.cluster_ca_certificate)
  }

  version = "~> 0.10.0"
}