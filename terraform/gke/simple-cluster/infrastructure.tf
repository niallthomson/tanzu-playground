module "infrastructure" {
  source = "../../modules/infrastructure/gcp"

  project                    = var.project
  environment_name           = var.environment_name
  region                     = var.region
  dns_zone_name             = module.dns.zone_name
  acme_email                 = var.acme_email
  apply_service_account_name = module.helm.service_account_name
  ytt_lib_dir      = "${path.module}/../../../ytt-libs"
  domain           = module.dns.base_domain

  blocker = ""
}