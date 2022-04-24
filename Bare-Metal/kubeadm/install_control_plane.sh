sudo apt update -y

# Install transport layer
sudo apt-get install -y apt-transport-https curl

# Install Kubernetes package on Ubuntu
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update -y 

# Install and configure the CRI-O container runtime
OS=xUbuntu_20.04
VERSION=1.22

echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list

curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/Release.key | apt-key add -
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | apt-key add -

sudo apt update -y
sudo apt install cri-o cri-o-runc -y

sudo systemctl daemon-reload
sudo systemctl enable crio --now

# Check to see CRI-O is installed properly
apt-cache policy cri-o

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

# Install and configure Kubeadm
sudo apt-get install -y kubelet kubeadm kubectl

apt-mark hold kubelet kubeadm kubectl

# ip_address=172.18.0.4
# cidr=172.18.0.0/16
# publicIP=20.232.11.27
# kubeadm init --control-plane-endpoint $publicIP --apiserver-advertise-address $ip_address --pod-network-cidr=$cidr --upload-certs

# # to start using your cluster, you need to configure your home user settings
# user=mike
# sudo su $user
# mkdir -p $HOME/.kube
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config

# # Networking: Weave
# # If you don't want to use Weave, you can see the network frameworks listed here: https://kubernetes.io/docs/concepts/cluster-administration/addons/
# export kubever=$(kubectl version | base64 | tr -d '\n')
# kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"