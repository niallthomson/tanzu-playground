# Terraform: cf-for-k8s on AWS via Tanzu Mission Control

This Terraform module installs `cf-for-k8s` (Cloud Foundry on Kubernetes) using Tanzu Mission Control on AWS.

It will:
- Create a TMC cluster on AWS of the correct minimal size
- Create an AWS Route53 DNS hosted zone and wire it up to an existing base zone
- Install `cf-for-k8s` from the official `ytt` configuration
- Install `external-dns` and ensure its configured correctly
- Output information to connect to the Cloud Foundry API endpoint

Example:

```
module "cf-for-k8s" {
  source = "github.com/niallthomson/tanzu-playground//terraform/tmc/aws/cf-for-k8s"

  tmc_key             = "<tmc api key>"
  tmc_cluster_group   = "my-cluster-group"
  tmc_account_name    = "AWS-account"
  tmc_ssh_key_name    = "default"

  acme_email          = "nthomson@pivotal.io"
  base_hosted_zone_id = "ZDZTEPQIQJB05"

  environment_name    = "demo"
  dns_prefix          = "demo"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| acme\_email | Email address that will be used for Lets Encrypt certificate registration | `string` | n/a | yes |
| base\_hosted\_zone\_id | The ID of the AWS Route53 DNS zone that already exists and is resolvable | `string` | n/a | yes |
| dns\_prefix | The DNS prefix that will be used to generate a unique domain from the base domain | `string` | n/a | yes |
| environment\_name | A name for the environment, which is used for various IaaS resources | `string` | n/a | yes |
| tmc\_account\_name | The Tanzu Mission Control account name to use | `string` | n/a | yes |
| tmc\_cluster\_group | The Tanzu Mission Control cluster group to use | `string` | n/a | yes |
| tmc\_key | A valid Tanzu Mission Control API key | `string` | n/a | yes |
| tmc\_ssh\_key\_name | The Tanzu Mission Control SSH key name | `string` | n/a | yes |
| availability\_zones | The AWS availability zones to use within the selected region | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| kubernetes\_version | Version of Kubernetes to use for the cluster | `string` | `"1.16.4-1-amazon2"` | no |
| master\_instance\_type | The EC2 instance type of the Kubernetes master nodes | `string` | `"m5.large"` | no |
| node\_pool\_instance\_type | The EC2 instance type of the Kubernetes worker nodes | `string` | `"m5.large"` | no |
| region | The AWS region in which components will be deployed | `string` | `"us-west-2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cf\_admin\_password | Cloud Foundry admin password |
| cf\_admin\_username | Cloud Foundry admin username |
| cf\_api\_endpoint | Cloud Foundry API endpoint |