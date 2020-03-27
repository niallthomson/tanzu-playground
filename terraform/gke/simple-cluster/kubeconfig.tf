data "template_file" "kubeconfig" {
  template = file("${path.module}/templates/kubeconfig")
  vars = {
    server = google_container_cluster.default.endpoint
    ca_cert = google_container_cluster.default.master_auth.0.cluster_ca_certificate
    token = data.google_client_config.current.access_token
  }
}

resource "local_file" "kubeconfig" {
  content  = data.template_file.kubeconfig.rendered
  
  filename = "${path.module}/kubeconfig"
}