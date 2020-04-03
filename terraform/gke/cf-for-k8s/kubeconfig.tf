module "kubeconfig" {
  source = "../../modules/generate-kubeconfig"

  endpoint       = "https://${google_container_cluster.default.endpoint}"
  certificate_ca = base64decode(google_container_cluster.default.master_auth.0.cluster_ca_certificate)
  token          = data.google_client_config.current.access_token
}