1. Run the configuration in the `equinixprovider` Terraform module
2. Once the config finishes, you'll see four outputs:
   - privateIP1
   - privateIP2
   - publicIP1
   - publicIP2
3. SSH into `publicIP1`
4. Take note of `publicIP1` and `privateIP1`
5. Open up the `control_plane_setup.sh` script in the `kubeadm` directory

In the `control_plane_setup.sh` script, you'll see three variables:
ip_address=
cidr=
publicIP=

Update the variables with the proper values from `publicIP1` and `privateIP1`.

6. Run the `control_plane_setup.sh` after you put in the variable values

After the script is complete, you'll see the output for Kubeadm and the output on how to join new Control Planes and Worker Nodes. For more information on this, check out the [join commands page](https://github.com/AdminTurnedDevOps/Kubernetes-Quickstart-Environments/blob/main/Bare-Metal/kubeadm/joincommands.md)