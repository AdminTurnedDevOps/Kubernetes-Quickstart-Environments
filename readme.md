# Kubernetes Quickstart Environments

Code to create and clean up Kubernetes environments in the cloud and on-prem.

![](images/k8s.png)

## Description

If you need to create Kubernetes environments for:
- Cloud
- On-prem
- Hybrid environments

Take a look at the code in this repo!

All of the Infrastructure-as-Code to create environments is written in Terraform

All of the configuration code to configure the environments is written in *TBD*

Scripts are written in Bash and Go

### Dependencies

* Terraform
* A Code editor like VS Code

## Environments
1. Bare Metal
    - [Equinix](https://github.com/AdminTurnedDevOps/Kubernetes-Quickstart-Environments/tree/main/Bare-Metal/EquinixMetal) and [Kubeadm](https://github.com/AdminTurnedDevOps/Kubernetes-Quickstart-Environments/blob/main/Bare-Metal/kubeadm/instructions_for_kubeadm/kubeadm_on_equinix/read.md)

2. GCP
    - [GKE](https://github.com/AdminTurnedDevOps/Kubernetes-Quickstart-Environments/tree/main/Google/GKE)
    - [Anthos Bare Metal](https://github.com/AdminTurnedDevOps/Kubernetes-Quickstart-Environments/tree/main/Google/anthos-bare-metal)
    - [Anthos In The Cloud](https://github.com/AdminTurnedDevOps/Kubernetes-Quickstart-Environments/tree/main/Google/anthos-in-the-cloud)
3. Azure
    - [AKS](https://github.com/AdminTurnedDevOps/Kubernetes-Quickstart-Environments/tree/main/azure/aks)
    - [AKS With Virtual Kubelet For ACI](https://github.com/AdminTurnedDevOps/Kubernetes-Quickstart-Environments/tree/main/azure/aks-with-virtual-kubelet)
4. AWS
    - [EKS](https://github.com/AdminTurnedDevOps/Kubernetes-Quickstart-Environments/tree/main/aws/eks)
## Authors

Contributors names and contact info

[@TheNJDevOpsGuy](https://twitter.com/thenjdevopsguy)

## WIP
As of April 2022, this project is still being worked on. The code that currently exists is ready for use, but there will be additional environments and configurations coming.