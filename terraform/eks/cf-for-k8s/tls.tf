module "acme" {
  source = "../../modules/acme/aws"

  dns_zone_id = module.dns.hosted_zone_id
  common_name = "*.${module.cf-for-k8s.sys_domain}"
  email       = var.acme_email
}