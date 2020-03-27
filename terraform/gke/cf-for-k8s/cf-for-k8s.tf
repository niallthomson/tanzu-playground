
module "cf-for-k8s" {
  source = "../../modules/cf-for-k8s"

  ytt_lib_dir      = "${path.module}/../../../ytt-libs"
  domain           = module.dns.base_domain

  tls_cert         = module.acme.cert_full_chain
  tls_key          = module.acme.cert_key
  tls_ca_cert      = module.acme.cert_ca

  blocker = google_container_cluster.default.endpoint
}