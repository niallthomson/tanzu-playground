module "infrastructure" {
  source = "../../../modules/infrastructure/aws"

  environment_name           = var.environment_name
  region                     = var.region
  hosted_zone_id             = module.dns.hosted_zone_id
  acme_email                 = var.acme_email
  apply_service_account_name = kubernetes_service_account.helm.metadata.0.name
  ytt_lib_dir      = "${path.module}/../../../../ytt-libs"
  domain           = module.dns.base_domain

  blocker = module.privileges.blocker
}