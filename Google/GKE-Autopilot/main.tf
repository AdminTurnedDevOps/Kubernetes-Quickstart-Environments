provider "google" {
  project = var.project_id
  region  = var.region
}
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  ip_allocation_policy {}

  network    = var.vpc_name
  subnetwork = var.subnet_name

  enable_autopilot = true
}
