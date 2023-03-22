clusterName=aksenvironment01
resourceGroup=devrelasaservice
wasmNodePool=wasmnodepool

az aks nodepool add \
    --resource-group $resourceGroup \
    --cluster-name $clusterName \
    --name $wasmNodePool \
    --node-count 2 \
    --workload-runtime WasmWasi 