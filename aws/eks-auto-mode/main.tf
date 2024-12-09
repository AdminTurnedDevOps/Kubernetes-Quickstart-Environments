terraform {
  backend "s3" {
    bucket = "terraform-state-k8senv"
    key    = "eks-terraform-automode1.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}


# IAM Role for EKS to have access to the appropriate resources
resource "aws_iam_role" "eks-iam-role" {
  name = "k8squickstart-eks-iam-role"

  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

## Recommended Policies For EKS Auto Mode Control Plane
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-iam-role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSBlockStoragePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy"
  role       = aws_iam_role.eks-iam-role.name
}
resource "aws_iam_role_policy_attachment" "AmazonEKSComputePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSComputePolicy"
  role       = aws_iam_role.eks-iam-role.name
}
resource "aws_iam_role_policy_attachment" "AmazonEKSLoadBalancingPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy"
  role       = aws_iam_role.eks-iam-role.name
}
resource "aws_iam_role_policy_attachment" "AmazonEKSNetworkingPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"
  role       = aws_iam_role.eks-iam-role.name
}

## EKS Worker Node Policies For Auto Mode
resource "aws_iam_role" "workernodes" {
  name = "eks-node-group-example"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodeMinimalPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodeMinimalPolicy"
  role       = aws_iam_role.workernodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryPullOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
  role       = aws_iam_role.workernodes.name
}

## Create the EKS cluster
resource "aws_eks_cluster" "k8squickstart-eks" {
  name     = "k8squickstart-cluster"
  role_arn = aws_iam_role.eks-iam-role.arn

#   enabled_cluster_log_types = ["api", "audit", "scheduler", "controllerManager"]
  version                   = var.k8sVersion

  access_config {
    authentication_mode = "API"
  }

  vpc_config {
    subnet_ids = [var.subnet_id_1, var.subnet_id_2]
  }

  compute_config {
    enabled       = true
    node_pools    = ["general-purpose", "system"]
    node_role_arn = aws_iam_role.workernodes.arn
  }

  kubernetes_network_config {
    elastic_load_balancing {
      enabled = true
    }
  }

  storage_config {
    block_storage {
      enabled = true
    }
  }

  bootstrap_self_managed_addons = false

  depends_on = [
    aws_iam_role.eks-iam-role,
  ]
}

# # ## Worker Nodes


# resource "aws_eks_node_group" "worker-node-group" {
#   cluster_name    = aws_eks_cluster.k8squickstart-eks.name
#   node_group_name = "k8squickstart-workernodes"
#   node_role_arn   = aws_iam_role.workernodes.arn
#   subnet_ids      = [var.subnet_id_1, var.subnet_id_2]
#   instance_types = ["p2.xlarge"]

#   scaling_config {
#     desired_size = var.desired_size
#     max_size     = 4
#     min_size     = var.min_size
#   }

#   depends_on = [
#     aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
#     #aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
#   ]
# }

# resource "aws_eks_addon" "csi" {
#   cluster_name = aws_eks_cluster.k8squickstart-eks.name
#   addon_name   = "aws-ebs-csi-driver"
# }
