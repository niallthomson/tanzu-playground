provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"

  version = "~> 1.4.0"
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = "none@paasify.org"
}

resource "null_resource" "acme_blocker" {
  provisioner "local-exec" {
    command = "echo 'unblocking on ${var.blocker}'"
  }
}

resource "acme_certificate" "certificate" {
  depends_on = [null_resource.acme_blocker]

  account_key_pem           = acme_registration.reg.account_key_pem
  common_name               = var.common_name
  subject_alternative_names = var.additional_domains

  dns_challenge {
    provider = "gcloud"

    config = {
      GCE_PROJECT             = var.project
      GCE_PROPAGATION_TIMEOUT = "360"
    }
  }
}