
module "certmanager" {
  source = "../../modules/certmanager/gcp"

  environment_name = local.full_environment_prefix
  project = var.project
  acme_email = var.acme_email
  dns_zone_name = module.dns.zone_name
  domain = module.dns.base_domain

  blocker = null_resource.cluster_blocker.id
}