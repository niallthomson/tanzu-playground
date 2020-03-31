module "certmanager" {
  source = "../../certmanager/gcp"

  environment_name           = var.environment_name
  project                    = var.project
  dns_zone_name              = var.dns_zone_name
  acme_email                 = var.acme_email
  domain                     = var.domain

  blocker = var.blocker
}

module "nginx_ingress" {
  source = "../../nginx-ingress"
  ytt_lib_dir      = var.ytt_lib_dir

  blocker = var.blocker
}

module "external_dns" {
  source = "../../external-dns/gcp"
  ytt_lib_dir      = var.ytt_lib_dir

  environment_name = var.environment_name
  domain_filter = var.domain
  zone_id_filter = var.dns_zone_name

  blocker = var.blocker
}

module "welcome_app" {
  source = "../../welcome-app"
  ytt_lib_dir      = var.ytt_lib_dir

  base_domain = var.domain

  blocker = var.blocker
}

resource "null_resource" "blocker" {
  depends_on = [
    module.nginx_ingress,
    //module.certmanager,
    //module.external_dns,
    module.welcome_app,
  ]
}

