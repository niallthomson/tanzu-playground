resource "local_file" "kubeconfig" {
  content  = data.tmc_kubeconfig.kubeconfig.content
  filename = "${path.module}/kubeconfig"
}

provider "helm" {
  version = "~> 1.1.0"

  kubernetes {
    config_path = local_file.kubeconfig.filename
  }

  load_config_file       = false
}