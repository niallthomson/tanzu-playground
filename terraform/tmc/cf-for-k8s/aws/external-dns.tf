module "external_dns" {
  source = "../../../modules/external-dns/aws"
  ytt_lib_dir      = local.ytt_lib_dir

  environment_name = var.environment_name
  domain_filter = module.dns.base_domain
  zone_id_filter = module.dns.hosted_zone_id

  enable_istio = true

  blocker = module.tmc_privileges.blocker
}