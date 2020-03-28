
module "cf-for-k8s" {
  source = "../../../modules/cf-for-k8s"

  ytt_lib_dir      = local.ytt_lib_dir
  domain           = module.dns.base_domain

  blocker = module.certmanager.blocker
}