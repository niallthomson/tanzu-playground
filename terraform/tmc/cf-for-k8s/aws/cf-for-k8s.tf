module "cf-for-k8s" {
  source = "../../../modules/cf-for-k8s"

  ytt_lib_dir      = local.ytt_lib_dir
  domain           = module.dns.base_domain

  tls_cert    = module.acme.cert_full_chain
  tls_key     = module.acme.cert_key
  tls_ca_cert = module.acme.cert_ca

  blocker = module.certmanager.blocker
}