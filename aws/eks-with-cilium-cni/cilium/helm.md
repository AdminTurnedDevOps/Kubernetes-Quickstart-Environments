helm repo add cilium https://helm.cilium.io/

helm install cilium cilium/cilium \
  --namespace kube-system \
  --set eni=true \
  --set enableIPv4Masquerade=false \
  --set tunnel=disabled \
  --set endpointRoutes.enabled=true \
  --set encryption.enabled=true \
  --set encryption.type=wireguard \
  --set l7Proxy=false \
  --set kubeProxyReplacement=strict
  

kubectl delete daemonset kube-proxy -n kube-system
