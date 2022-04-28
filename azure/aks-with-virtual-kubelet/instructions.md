After you deploy AKS, you'll need to add the virtual-kubelet add-on. To do that:

1. Run the following command to connect to the AKS cluster from a terminal:
```
az aks get-credentials --name aksenvironment-vkubelet-01 --resource-group resource_group_name
```

1. Add a new subnet to the AKS vNet. If you don't, you'll see an error similar to the below:
```
got HTTP response status code 400 error code \"SubnetDelegationsCannotChangeWhenSubnetUsedByResource\": Delegations of subnet cannot be changed from [] to [Microsoft.ContainerInstance/containerGroups] because it is being used by the resource
```

2. Run the `enable-addons` command:
```
az aks enable-addons --name aksenvironment-vkubelet-01 --resource-group resource_group_name --addons virtual-node --subnet-name akssubnetvkube
```