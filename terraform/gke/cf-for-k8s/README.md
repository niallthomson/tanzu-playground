# Terraform: cf-for-k8s on GKE

This Terraform module installs `cf-for-k8s` (Cloud Foundry on Kubernetes) on Google Kubernetes Engine.

It will:
- Create a GKE cluster of the correct minimal size
- Create a Google Cloud DNS hosted zone and wire it up to an existing base zone
- Install `cf-for-k8s` from the official `ytt` configuration
- Install `external-dns` and ensure its configured correctly
- Output information to connect to the Cloud Foundry API endpoint

Example:

```
module "cf-for-k8s" {
  source = "github.com/niallthomson/tanzu-playground//terraform/gke/cf-for-k8s"

  acme_email          = "nthomson@pivotal.io"
  base_zone_name      = "paasify-zone"

  environment_name    = "demo"
  dns_prefix          = "demo"

  project             = "fe-nthomson"
}
```

## Pre-requisites

The following are pre-requisites to run the above Terraform:
- Google Cloud Platform account, with `gcloud` logged in locally
- Terraform 0.12 installed
- [terraform-provider-k14s](https://github.com/k14s/terraform-provider-k14s) installed as a TF plugin
- DNS set up meeting the appropriate standards ([see here](/terraform/docs/dns.md))

<!-- REF -->