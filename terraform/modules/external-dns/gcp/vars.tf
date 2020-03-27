variable "environment_name" {
  
}

variable "namespace" {
  default = "external-dns"
}

variable "domain_filter" {

}

variable "zone_id_filter" {

}

variable "enable_istio" {
  default = false
}

variable "ytt_lib_dir" {}

variable "blocker" {
  default = ""
}