data "k14s_ytt" "certmanager" {
  files = concat([
    var.certmanager_yaml_url,
    "${var.ytt_lib_dir}/cert-manager/core"], 
    var.additional_files
  )

  values = merge({
    "certmanager.namespace" = "certmanager"
  }, var.values)
}