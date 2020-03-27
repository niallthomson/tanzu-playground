module "dns" {
  source = "../../modules/dns/gcp"

  environment_name = local.full_environment_prefix
  base_zone_name = var.base_zone_name
  dns_prefix            = var.dns_prefix
}