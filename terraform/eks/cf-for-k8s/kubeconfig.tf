module "kubeconfig" {
  source = "../../modules/generate-kubeconfig"

  endpoint       = aws_eks_cluster.cluster.endpoint
  certificate_ca = aws_eks_cluster.cluster.certificate_authority.0.data
  token          = data.aws_eks_cluster_auth.default.token
}

resource "local_file" "kubeconfig" {
  content  = module.kubeconfig.content
  filename = "${path.module}/kubeconfig"
}