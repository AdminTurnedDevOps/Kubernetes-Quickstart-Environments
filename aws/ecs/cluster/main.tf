terraform {
  backend "s3" {
    bucket = "terraform-state-k8senv"
    key    = "ecs-workload.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_ecs_cluster" "levancluster" {
  name = "levanecscluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}