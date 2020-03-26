provider "tmc" {
  api_key = var.tmc_key
}

data "tmc_cluster_group" "group" {
  name = "pa-nthomson"
}

resource "tmc_cluster" "cluster" {
  name              = "cnp-tmc-simple-${var.environment_name}"
  description       = "Automated cluster created for ${var.environment_name}"
  group             = data.tmc_cluster_group.group.name
  account_name      = "PA-nthomson"
  version           = var.kubernetes_version
  high_availability = false

  labels = {
    created_by   = "Terraform"
  }

  aws_config {
    control_plane_vm_flavor = var.master_instance_type
    ssh_key_name            = "default"
    vpc_cidr_block          = "10.0.0.0/16"
    region                  = var.region
    az_list                 = var.availability_zones
  }

  network_config {
    pod_cidr     = "192.168.0.0/16"
    service_cidr = "10.96.0.0/12"
  }
}

resource "tmc_node_pool" "pools" {
  cluster_name      = tmc_cluster.cluster.name
  name              = "pool-${count.index}"
  worker_node_count = 1

  node_labels = {
    az   = element(var.availability_zones, count.index)
  }

  aws_config {
    instance_type      = var.node_pool_instance_type
    zone               = element(var.availability_zones, count.index)
  }

  count = length(var.availability_zones)
}

data "tmc_kubeconfig" "kubeconfig" {
  name = tmc_cluster.cluster.provisioned_name
}

module "privileges" {
  source = "../../open-privileges"

  ytt_lib_dir      = "${path.module}/../../../../ytt-libs"

  blocker = join("", tmc_node_pool.pools.*.id)
}

provider "k14s" {
  kubeconfig_yml = data.tmc_kubeconfig.kubeconfig.content
}