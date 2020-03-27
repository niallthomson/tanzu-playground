variable "environment_name" {}

variable "kubernetes_version" {
  default = "1.16.4-1-amazon2"
}

variable "acme_email" {}

variable "base_zone_name" {}

variable "dns_prefix" {}

variable "master_instance_type" {
  default = "m5.large"
}

variable "node_pool_instance_type" {
  default = "t2.medium"
}

variable "project" {
  type = string
}

variable "region" {
  type = string
  default = "us-central1"
}

variable "zone" {
  type = string
  default = "us-central1-b"
}