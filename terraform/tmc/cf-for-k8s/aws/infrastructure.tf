module "infrastructure" {
  source = "../../../modules/infrastructure/aws"

  environment_name = local.full_environment_prefix
  region           = var.region
  hosted_zone_id   = module.dns.hosted_zone_id
  acme_email       = var.acme_email
  ytt_lib_dir      = local.ytt_lib_dir
  domain           = module.dns.base_domain
  enable_istio     = true

  blocker = module.tmc_privileges.blocker
}