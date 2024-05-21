helm repo add cilium https://helm.cilium.io/

  helm install cilium cilium/cilium \
  --namespace kube-system \
  --set eni.enabled=true \
  --set ipam.mode=eni \
  --set egressMasqueradeInterfaces=eth0 \
  --set tunnel=disabled \
  --set nodeinit.enabled=true \
  --set kubeProxyReplacement=strict

  

kubectl delete daemonset kube-proxy -n kube-system
