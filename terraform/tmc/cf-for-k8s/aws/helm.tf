resource "local_file" "kubeconfig" {
  content  = data.tmc_kubeconfig.kubeconfig.content
  filename = "${path.module}/kubeconfig"
}

provider "helm" {
  version = "~> 1.1.0"

  kubernetes {
    config_path = local_file.kubeconfig.filename
    host                   = data.tmc_kubeconfig.kubeconfig.server

    client_certificate     = base64decode(data.tmc_kubeconfig.kubeconfig.client_certificate)
    client_key             = base64decode(data.tmc_kubeconfig.kubeconfig.client_key)
    cluster_ca_certificate = base64decode(data.tmc_kubeconfig.kubeconfig.cluster_ca_certificate)
  }
}