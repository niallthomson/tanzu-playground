module "cf-for-k8s" {
  source = "../../modules/cf-for-k8s"

  ytt_lib_dir      = local.ytt_lib_dir
  domain           = module.dns.base_domain

  tls_cert    = module.acme.cert_full_chain
  tls_key     = module.acme.cert_key
  tls_ca_cert = module.acme.cert_ca

  registry_domain       = module.harbor.harbor_domain
  registry_repository   = "${module.harbor.harbor_domain}/library"
  registry_username     = module.harbor.harbor_admin_username
  registry_password     = module.harbor.harbor_admin_password

  blocker = module.infrastructure.blocker
}