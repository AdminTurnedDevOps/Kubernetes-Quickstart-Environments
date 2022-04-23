terraform {
  required_providers {
    metal = {
      source = "equinix/metal"
      version = "3.3.0-alpha.3"
    }
  }
}

provider "metal" {
  auth_token = var.token
}

resource "metal_device" "k8sservers" {
  count = 5
  project_id = var.project_id
  hostname = "${var.hostname}-${count.index}"
  operating_system = var.OS
  plan             = var.server_size
  facilities       = [var.datacenter]
  billing_cycle    = "hourly"

  ip_address {
    type = "private_ipv4"
    cidr = 30
  }
}