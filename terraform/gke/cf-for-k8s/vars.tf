variable "environment_name" {
  description = "A name for the environment, which is used for various IaaS resources"
  type        = string
}

variable "kubernetes_version" {
  description = "Version of Kubernetes to use for the cluster"
  default     = "1.15.9-gke.26"
  type        = string
}

variable "acme_email" {
  description = "Email address that will be used for Lets Encrypt certificate registration"
  type        = string
}

variable "base_zone_name" {
  description = "The name of the Google Cloud DNS zone that already exists and is resolvable"
  type        = string
}

variable "dns_prefix" {
  description = "The DNS prefix that will be used to generate a unique domain from the base domain"
  type        = string
}

/*variable "master_instance_type" {
  description = "The EC2 instance type of the Kubernetes master nodes"
  default     = "m5.large"
}

variable "node_pool_instance_type" {
  description = "The EC2 instance type of the Kubernetes worker nodes"
  default     = "t2.medium"
}*/

variable "project" {
  description = "The Google Cloud project to use"
  type        = string
}

variable "region" {
  description = "The GCP region where the resources will be deployed"
  default = "us-central1"
  type = string
}

variable "zone" {
  description = "The default GCP zone to use where applicable"
  default = "us-central1-b"
  type = string
}