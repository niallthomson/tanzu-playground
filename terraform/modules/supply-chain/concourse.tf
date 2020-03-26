resource "random_string" "concourse_user_password" {
  length  = 8
  special = false
}

data "template_file" "concourse_config" {
  template = file("${path.module}/templates/concourse-values.yml")

  vars = {
    concourse_domain = local.concourse_domain
    uaa_domain       = local.uaa_domain
    user_password    = random_string.concourse_user_password.result
  }
}

data "helm_repository" "concourse" {
  name = "concourse"
  url  = "https://concourse-charts.storage.googleapis.com/"
}

resource "helm_release" "concourse" {
  depends_on = [null_resource.uaa_blocker]

  name       = "concourse"
  namespace  = "concourse"
  repository = data.helm_repository.concourse.name
  chart      = "concourse"
  version    = "9.1.1"

  values = [data.template_file.concourse_config.rendered]

  provisioner "local-exec" {
    command = "sleep 60"
  }
}

