module "infrastructure" {
  source = "../../../modules/infrastructure/aws"

  environment_name           = local.full_environment_prefix
  region                     = var.region
  hosted_zone_id             = module.dns.hosted_zone_id
  acme_email                 = var.acme_email
  apply_service_account_name = module.helm.service_account_name
  ytt_lib_dir      = "${path.module}/../../../../ytt-libs"
  domain           = module.dns.base_domain

  blocker = module.privileges.blocker
}