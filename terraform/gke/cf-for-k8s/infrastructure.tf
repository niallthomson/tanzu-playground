module "infrastructure" {
  source = "../../modules/infrastructure/gcp"

  project          = var.project
  environment_name = local.full_environment_prefix
  region           = var.region
  dns_zone_name    = module.dns.zone_name
  acme_email       = var.acme_email
  ytt_lib_dir      = local.ytt_lib_dir
  domain           = module.dns.base_domain
  enable_istio     = true

  blocker = null_resource.cluster_blocker.id
}