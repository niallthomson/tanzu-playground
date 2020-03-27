module "acme" {
  source = "../../modules/acme/gcp"

  project = var.project
  common_name = "*.${module.cf-for-k8s.sys_domain}"
  email       = var.acme_email

  blocker = module.dns.blocker
}