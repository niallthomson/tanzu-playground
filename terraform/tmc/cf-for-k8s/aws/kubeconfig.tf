resource "local_file" "kubeconfig" {
  content  = data.tmc_kubeconfig.kubeconfig.content
  filename = "${path.module}/kubeconfig"
}