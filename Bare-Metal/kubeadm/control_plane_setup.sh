# Define variables for the `kubeadm init` command. Examples below.
sudo su -

user=k8stest
pass='Password12!@'
sudo useradd -m -d /home/$user $user
sudo echo "$user:$pass" | chpasswd
usermod -aG sudo $user

exit


#######
Depending on where you are deploying, you could either have just a public subnet, or a public and private subnet
If you have just a public subnet, use the same value for the ip_address and publicIP, along with the CIDR range
If you have a private and public subnet, use the public IP for the publicIP, the private IP for the ip_address, and the private IP range for the CIDR
#######
ip_address=172.17.0.4
cidr=172.17.0.0/16
publicIP=40.117.168.164

sudo kubeadm init --control-plane-endpoint $publicIP --apiserver-advertise-address $ip_address --pod-network-cidr=$cidr --upload-certs

#######

If you are deploying in the cloud, you may find yourself in a situation where the init fails because the Kubelet connect communicate with the API server

This typically happens in public clouds due to network restrictions

If it happens to you, open up the following ports: https://kubernetes.io/docs/reference/ports-and-protocols/

#######

# To start using your Kubernetes cluster, you need to configure your home user settings
su -l k8stest
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Networking: Weave
# If you don't want to use Weave, you can see the network frameworks listed here: https://kubernetes.io/docs/concepts/cluster-administration/addons/
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

