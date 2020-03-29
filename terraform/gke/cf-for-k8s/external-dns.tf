
module "external_dns" {
  source = "../../modules/external-dns/gcp"
  ytt_lib_dir      = local.ytt_lib_dir

  environment_name = var.environment_name
  domain_filter = module.dns.base_domain
  zone_id_filter = module.dns.zone_name

  enable_istio = true

  blocker = null_resource.cluster_blocker.id
}