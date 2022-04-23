## Control Plane

When installing/adding a control plane to a Kubernetes cluster, the options may vary based on where you're installing it.

For example, if you're installing Kubeadm in the cloud, say Azure, you'll need to specify the `--control-plane-endpoint` switch when running `kube init`.

The reason why is explained in the docs found [here](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/#create-load-balancer-for-kube-apiserver) on creating highly available clusters with Kubeadm.

 The Control Plane endpoint can be a load balancer sitting in front of the Kubernetes API or the servers public IP address.


### Control Plane Join

When you run `kubeadmin init` in the `install_control_plane.sh` script, you'll see an output that tells you about the server with a command similar to the one below. You can copy/paste it into the new Control Plane server to join the new Control Plane server to the Kubernetes cluster.

```
kubeadm join 20.232.11.27:6443 --token p2paxv.aqtlrcd4ymaoly1y --discovery-token-ca-cert-hash sha256:44485769d06937cfc8a37c443f201d525aeb5ffcf52865b61793d6931c65e117 --control-plane
```

### Worker Node Join

When you run `kubeadmin init` in the `install_control_plane.sh` script on the Control Plane, you'll see an output that tells you about the server with a command similar to the one below. You can copy/paste it into the new Worker Node server to join the new Worker Node server to the Kubernetes cluster.

```
kubeadm join 172.18.0.4:6443 --token q8pao2.6bub77ub8qvjdees --discovery-token-ca-cert-hash sha256:c431198db7aa4d89ca390a3a07e535522a0679335290b2e27e21782aa414bdae
```