module "helm" {
  source = "../../../modules/helm"

  blocker = join("", tmc_node_pool.pools.*.id)
}

resource "local_file" "kubeconfig" {
  content  = data.tmc_kubeconfig.kubeconfig.content
  filename = "${path.module}/kubeconfig"
}

provider "helm" {
  install_tiller = true
  tiller_image = "gcr.io/kubernetes-helm/tiller:v2.13.1"
  service_account = module.helm.service_account_name

  version = "~> 0.10.0"

  kubernetes {
    config_path = local_file.kubeconfig.filename
  }
}