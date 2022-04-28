After you deploy AKS, you'll need to add the virtual-kubelet add-on. To do that:

```
az aks enable-addons --name aksenvironment-vkubelet-01 --resource-group resource_group_name --addons virtual-node --subnet-name aks_vet_subnet_name
```