data "template_file" "kubeconfig" {
  template = file("${path.module}/templates/kubeconfig.tmpl")
  vars = {
    server = aws_eks_cluster.cluster.endpoint
    ca_cert = aws_eks_cluster.cluster.certificate_authority.0.data
    token = data.aws_eks_cluster_auth.default.token
  }
}

resource "local_file" "kubeconfig" {
  content  = data.template_file.kubeconfig.rendered
  filename = "${path.module}/kubeconfig"
}