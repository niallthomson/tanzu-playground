data "template_file" "kpack" {
  template = file("${path.module}/templates/kpack.yml")
}

module "install_kpack" {
  source = "../apply"

  name = "install-kpack"
  yaml = data.template_file.kpack.rendered
}

data "template_file" "kpack_config" {
  template = file("${path.module}/templates/kpack-harbor-registry-secret.yml")

  vars = {
    harbor_domain = local.harbor_domain
  }
}

module "install_kpack_config" {
  source = "../apply"

  name = "install-kpack-config"
  yaml = data.template_file.kpack_config.rendered
}

data "template_file" "kpack_viz" {
  template = file("${path.module}/templates/kpack-viz.yml")

  vars = {
    domain = local.kpack_viz_domain
  }
}

module "install_kpack_viz" {
  source = "../apply"

  name = "install-kpack-viz"
  yaml = data.template_file.kpack_viz.rendered
}

