# Define variables for the `kubeadm init` command. Examples below.
ip_address=10.66.89.134
cidr=10.66.0.0/16
publicIP=136.144.59.119

kubeadm init --control-plane-endpoint $publicIP --apiserver-advertise-address $ip_address --pod-network-cidr=$cidr --upload-certs

# To start using your Kubernetes cluster, you need to configure your home user settings
user=root
sudo su $user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Networking: Weave
# If you don't want to use Weave, you can see the network frameworks listed here: https://kubernetes.io/docs/concepts/cluster-administration/addons/
export kubever=$(kubectl version | base64 | tr -d '\n')
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"