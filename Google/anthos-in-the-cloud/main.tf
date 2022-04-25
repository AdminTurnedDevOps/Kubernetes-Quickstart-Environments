terraform {
  required_providers {
    google-beta = {
      source = "hashicorp/google-beta"
      version = ">= 3.67.0"
    }
  }
}

provider "google-beta" {
  project = var.project_id
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.vpc_name
  subnetwork = var.subnet_name
}

resource "google_container_node_pool" "nodes" {
  name       = "${google_container_cluster.primary.name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
    }

    machine_type = "n1-standard-1"
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

resource "google_gke_hub_membership" "anthos_registration" {
  provider = google-beta
  project_id = var.project_id
  membership_id = "${var.clustername}-fleet"
  endpoint {
    gke_cluster {
     resource_link = "${container.googleapis.com/google_container_cluster.primary.id}"
    }
  }
}

workload_identity_config {
  identity_namespace = "${var.project_id.svc.id.goog}"
}

authority {
  issuer = "${https://container.googleapis.com/v1/google_container_cluster.primary.id}"
}