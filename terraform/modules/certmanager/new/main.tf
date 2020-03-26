module "common" {
  source = "../common"

  ytt_lib_dir      = var.ytt_lib_dir
  additional_files = ["${var.ytt_lib_dir}/cert-manager/aws"]

  values = {
    "certmanager.region"           = var.region
    "certmanager.acmeEmail"        = var.acme_email
    "certmanager.domain"           = var.domain
    "certmanager.hostedZoneID"     = var.hosted_zone_id
    "certmanager.accessKeyID"      = aws_iam_access_key.key.id
    "certmanager.secretAccessKey"  = aws_iam_access_key.key.secret
  }
}