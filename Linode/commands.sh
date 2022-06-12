pip3 --version
pip3 install linode-cli
linode-cli --help
linode-cli configure
linode-cli lke clusters-list

linode-cli lke cluster-create \
  --label kodekloudtest \
  --region us-central \
  --k8s_version 1.23 \
  --node_pools.type g6-standard-4 --node_pools.count 3