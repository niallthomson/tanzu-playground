
module "cf-for-k8s" {
  source = "../../modules/cf-for-k8s"

  ytt_lib_dir      = "${path.module}/../../../ytt-libs"
  domain           = module.dns.base_domain

  blocker = google_container_cluster.default.endpoint
}