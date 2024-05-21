#!/bin/bash
sudo apt update -y

# Install transport layer
sudo apt-get install -y apt-transport-https curl

# Add Kubernetes Signing Key
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add Software Repositories
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update -y 

sudo su -

# Install and configure the CRI-O container runtime
OS=xUbuntu_22.04
VERSION=1.22

echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list

curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/Release.key | apt-key add -
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | apt-key add -

exit

sudo apt update -y
sudo apt install cri-o cri-o-runc -y

sudo systemctl daemon-reload
sudo systemctl enable crio --now

# Check to see CRI-O is installed properly
apt-cache policy cri-o

# Turn off swap
sudo swapoff -a

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
