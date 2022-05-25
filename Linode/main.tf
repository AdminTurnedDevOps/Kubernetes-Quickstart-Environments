terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "1.27.1"
    }
  }
}

provider "linode" {
  token = var.token
}

resource "linode_lke_cluster" "kodekloud" {
    label       = "my-cluster"
    k8s_version = "1.23"
    region      = "us-central"
    tags        = ["prod"]

    pool {
        type  = "g6-standard-2"
        count = 3

        # autoscaler {
        #   min = 3
        #   max = 10
        # }
    }
}

output "kubeconfig" {
   value = linode_lke_cluster.kodekloud.kubeconfig
   sensitive = true
}