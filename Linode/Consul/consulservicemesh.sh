sudo wget https://get.helm.sh/helm-v3.6.1-linux-amd64.tar.gz

1. Install Helm

helm repo add hashicorp https://helm.releases.hashicorp.com

helm search repo hashicorp/consul

helm repo update

helm install consul hashicorp/consul --set global.name=consul -f consul.yaml