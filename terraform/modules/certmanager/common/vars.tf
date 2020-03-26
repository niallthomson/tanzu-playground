variable "additional_files" {
  type = list(string)
}

variable "values" {
  type = map
}

variable "ytt_lib_dir" {}

variable "certmanager_yaml_url" {
  default = "https://github.com/jetstack/cert-manager/releases/download/v0.14.0/cert-manager.yaml"
}