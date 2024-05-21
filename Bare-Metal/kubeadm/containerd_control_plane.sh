#!/bin/bash
sudo apt update -y

# Install transport layer
sudo apt-get install -y apt-transport-https curl

# Install Kubernetes package on Ubuntu
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update -y

# Configure Containerd
sudo tee /etc/modules-load.d/containerd.conf<<EOF
overlay
br_netfilter
EOF

sudo sysctl --system

sudo apt install curl gnupg2 software-properties-common apt-transport-https ca-certificates -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt update

sudo apt install containerd.io -y

sudo su -

mkdir -p /etc/containerd

containerd config default>/etc/containerd/config.toml

exit

sudo systemctl restart containerd

sudo systemctl enable containerd

# Turn off swap
swapoff -a

# sysctl settings and ip tables
sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

# Install and configure Kubeadm with the latest version of Kubernetes.
sudo apt-get install -y kubelet kubeadm kubectl

# To install a specific version of Kubernetes (not the latest), you can use the following...
# Example: sudo apt-get install -qy kubelet=1.25.5-00 kubectl=1.25.5-00 kubeadm=1.25.5-00

# You can see all Kubernetes versions available for Kubeadm like this: `apt list -a kubeadm`

sudo apt-get install -qy kubelet=<version> kubectl=<version> kubeadm=<version>

sudo apt-mark hold kubelet kubeadm kubectl