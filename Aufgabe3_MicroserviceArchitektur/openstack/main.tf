terraform {
  required_version = ">= 1.6.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = ">= 1.54.1"
    }
  }
}

provider "openstack" {
  auth_url    = var.auth_url
  user_name   = var.user_name
  password    = var.password
  tenant_name = var.tenant_name
  region      = var.region
}

data "openstack_networking_network_v2" "net" {
  name = var.network_name
}

resource "openstack_compute_keypair_v2" "kp" {
  name       = var.keypair
  public_key = file("~/.ssh/${var.keypair}.pub")
}

resource "openstack_compute_instance_v2" "master" {
  name            = "k8s-master"
  image_name      = var.image_name
  flavor_name     = var.flavor_master
  key_pair        = openstack_compute_keypair_v2.kp.name
  security_groups = ["default"]
  network {
    uuid = data.openstack_networking_network_v2.net.id
  }
  user_data = file("${path.module}/cloud-init/master.yaml")
}

resource "openstack_compute_instance_v2" "workers" {
  count           = var.worker_count
  name            = "k8s-worker-${count.index}"
  image_name      = var.image_name
  flavor_name     = var.flavor_worker
  key_pair        = openstack_compute_keypair_v2.kp.name
  security_groups = ["default"]
  network {
    uuid = data.openstack_networking_network_v2.net.id
  }
  user_data = file("${path.module}/cloud-init/worker.yaml")
}

output "master_ip" {
  value = openstack_compute_instance_v2.master.network.0.fixed_ip_v4
}
