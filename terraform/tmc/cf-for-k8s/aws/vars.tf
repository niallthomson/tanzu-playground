variable "environment_name" {
  description = "A name for the environment, which is used for various IaaS resources"
  type        = string
}

variable "kubernetes_version" {
  description = "Version of Kubernetes to use for the cluster"
  default     = "1.16.4-1-amazon2"
  type        = string
}

variable "acme_email" {
  description = "Email address that will be used for Lets Encrypt certificate registration"
  type        = string
}

variable "region" {
  description = "The AWS region in which components will be deployed"
  default     = "us-west-2"
  type        = string
}

variable "availability_zones" {
  description = "The AWS availability zones to use within the selected region"
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
  type        = list(string)
}

variable "base_hosted_zone_id" {
  description = "The ID of the AWS Route53 DNS zone that already exists and is resolvable"
  type        = string
}

variable "dns_prefix" {
  description = "The DNS prefix that will be used to generate a unique domain from the base domain"
  type        = string
}

variable "tmc_key" {
  description = "A valid Tanzu Mission Control API key"
  type        = string
}

variable "tmc_account_name" {
  description = "The Tanzu Mission Control account name to use"
  type        = string
}

variable "tmc_cluster_group" {
  description = "The Tanzu Mission Control cluster group to use"
  type        = string
}

variable "tmc_ssh_key_name" {
  description = "The Tanzu Mission Control SSH key name"
  type        = string
}

variable "master_instance_type" {
  description = "The EC2 instance type of the Kubernetes master nodes"
  default     = "m5.large"
  type        = string
}

variable "node_pool_instance_type" {
  description = "The EC2 instance type of the Kubernetes worker nodes"
  default     = "m5.large"
  type        = string
}