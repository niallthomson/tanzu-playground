
module "harbor" {
  source = "../../modules/harbor"

  domain = module.dns.base_domain

  blocker = module.infrastructure.blocker
}