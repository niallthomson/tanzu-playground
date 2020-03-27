
module "external_dns" {
  source = "../../modules/external-dns/gcp"
  ytt_lib_dir      = "${path.module}/../../../ytt-libs"

  environment_name = var.environment_name
  domain_filter = module.dns.base_domain
  zone_id_filter = module.dns.zone_name

  enable_istio = true

  blocker = google_container_cluster.default.endpoint
}