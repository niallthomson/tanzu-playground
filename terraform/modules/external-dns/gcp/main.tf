module "common" {
  source = "../common"

  namespace = var.namespace
  domain_filter = ""
  zone_id_filter = ""
  ytt_lib_dir = var.ytt_lib_dir
  dns_provider = "google"

  blocker = var.blocker
}