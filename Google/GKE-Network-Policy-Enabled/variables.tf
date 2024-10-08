variable "project_id" {
  type = string
  default = "gold-mode-297211"
}

variable "region" {
  type = string
  default = "us-east1"
}

variable "machine_type" {
  type = string
  default = "e2-standard-4"
}

variable "vpc_name" {
  type = string
  default = "default"
}

variable "subnet_name" {
  type = string
  default = "default"
}

variable "node_count" {
  type = string
  default = 2
}

variable "cluster_name" {
  type = string
  default = "gkek8senv"
}

variable "k8s_version" {
  type = string
  default = "1.29.4-gke.1043002"
}