
module "certmanager" {
  source = "../../../modules/certmanager/aws"

  environment_name = local.full_environment_prefix
  region = var.region
  acme_email = var.acme_email
  hosted_zone_id = module.dns.hosted_zone_id
  domain = module.dns.base_domain

  blocker = module.tmc_privileges.blocker
}