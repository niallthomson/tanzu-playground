resource "null_resource" "in_blocker" {
  provisioner "local-exec" {
    command = "echo ${var.blocker}"
  }
}

module "certmanager" {
  source = "../../certmanager/aws"

  environment_name           = var.environment_name
  region                     = var.region
  hosted_zone_id             = var.hosted_zone_id
  acme_email                 = var.acme_email
  domain                     = var.domain

  blocker = null_resource.in_blocker.id
}

module "nginx_ingress" {
  source = "../../nginx-ingress"
  ytt_lib_dir      = var.ytt_lib_dir

  blocker = null_resource.in_blocker.id
}

module "external_dns" {
  source = "../../external-dns/aws"
  ytt_lib_dir      = var.ytt_lib_dir

  environment_name = var.environment_name
  domain_filter    = var.domain
  zone_id_filter   = var.hosted_zone_id
  enable_istio     = var.enable_istio

  blocker = null_resource.in_blocker.id
}

module "welcome_app" {
  source = "../../welcome-app"
  ytt_lib_dir      = var.ytt_lib_dir

  base_domain = var.domain

  blocker = var.blocker
}

resource "null_resource" "out_blocker" {
  depends_on = [
    module.nginx_ingress,
    module.certmanager,
    module.external_dns,
    module.welcome_app,
  ]
}

