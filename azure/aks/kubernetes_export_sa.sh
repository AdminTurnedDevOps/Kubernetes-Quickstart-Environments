#!/bin/bash
set -e
set -o pipefail

# Add user to k8s using service account, no RBAC (must create RBAC after this script)
if [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$2" ]]; then
 echo "usage: $0 <service_account_name> <namespace>"
 echo "ex: sh ./kubeconfig-exporter/kubernetes_export_sa.sh cd-user cd-user"
 exit 1
fi

SERVICE_ACCOUNT_NAME=$1
NAMESPACE="$2"
KUBECFG_FILE_NAME="tmp/k8s-${SERVICE_ACCOUNT_NAME}-${NAMESPACE}-conf-${RANDOM}.conf"
TARGET_FOLDER="tmp/"
SERVER_URL=""
TOKEN=""

create_cluster_role_binding(){
   echo -e "\\nCreating cluster role binding of name ${SERVICE_ACCOUNT_NAME} with clusterRole cluster-admin" 
   kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: devtroncd
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: $SERVICE_ACCOUNT_NAME
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: $SERVICE_ACCOUNT_NAME
    namespace: devtroncd
EOF
echo "cluster rolebinding created"
}

create_target_folder() {
    echo -n "Creating target directory to hold files in ${TARGET_FOLDER}..."
    mkdir -p "${TARGET_FOLDER}"
    printf "done"
}

create_service_account() {
    echo -e "\\nCreating a service account in ${NAMESPACE} namespace: ${SERVICE_ACCOUNT_NAME}"
    kubectl create sa "${SERVICE_ACCOUNT_NAME}" --namespace "${NAMESPACE}"
}

create_serviceaccount_token(){
    echo -e "\\nCreating service account token in ${NAMESPACE} namespace: ${SERVICE_ACCOUNT_NAME}\n"

    TOKEN=$(kubectl create token "${SERVICE_ACCOUNT_NAME}" -n "${NAMESPACE}")
}

create_secret(){
    echo -e "creating secret of service account ${SERVICE_ACCOUNT_NAME} on ${NAMESPACE}"
    kubectl apply -n "${NAMESPACE}" -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: $SERVICE_ACCOUNT_NAME
  annotations:
    kubernetes.io/service-account.name: $SERVICE_ACCOUNT_NAME
type: kubernetes.io/service-account-token
EOF
echo "secret created"
}

get_secret_name_from_secret() {
    echo -e "\\nGetting secret of service account ${SERVICE_ACCOUNT_NAME} on ${NAMESPACE}"
    SECRET_NAME=$(kubectl get secret "${SERVICE_ACCOUNT_NAME}" --namespace="${NAMESPACE}" -o=jsonpath={.metadata.name})
    echo "Secret name: ${SECRET_NAME}"
 }

get_secret_name_from_service_account() {
    echo -e "\\nGetting secret of service account ${SERVICE_ACCOUNT_NAME} on ${NAMESPACE}"
    SECRET_NAME=$(kubectl get sa "${SERVICE_ACCOUNT_NAME}" --namespace="${NAMESPACE}" -o=jsonpath='{.secrets[*].name}')
    echo "Secret name: ${SECRET_NAME}"
}

extract_ca_crt_from_secret() {
    echo -e -n "\\nExtracting ca.crt from secret..."
    kubectl get secret --namespace "${NAMESPACE}" "${SECRET_NAME}" -o=jsonpath="{.data.ca\.crt}"| base64 --decode > "${TARGET_FOLDER}/ca.crt"
    printf "done"
}

get_user_token_from_secret() {
    echo -e -n "\\nGetting user token from secret..."
    TOKEN=$(kubectl get secret --namespace "${NAMESPACE}" "${SECRET_NAME}" -o=jsonpath={.data.token}|base64 --decode)
    printf "done"
}

set_kube_config_values() {
    context=$(kubectl config current-context)
    echo -e "\\nSetting current context to: $context"

    CLUSTER_NAME=$(kubectl config get-contexts "$context" | awk '{print $3}' | tail -n 1)
    echo "Cluster name: ${CLUSTER_NAME}"

   SERVER_URL=$(kubectl config view \
    -o jsonpath="{.clusters[?(@.name == \"${CLUSTER_NAME}\")].cluster.server}")


    # Set up the config
    echo -e "\\nPreparing k8s-${SERVICE_ACCOUNT_NAME}-${NAMESPACE}-conf"
    echo -n "Setting a cluster entry in kubeconfig..."
    kubectl config set-cluster "${CLUSTER_NAME}" \
    --kubeconfig="${KUBECFG_FILE_NAME}" \
    --server="${SERVER_URL}" \
    --certificate-authority="${TARGET_FOLDER}/ca.crt" \
    --embed-certs=true

    echo -n "Setting token credentials entry in kubeconfig..."
    kubectl config set-credentials \
    "${SERVICE_ACCOUNT_NAME}-${NAMESPACE}-${CLUSTER_NAME}" \
    --kubeconfig="${KUBECFG_FILE_NAME}" \
    --token="${TOKEN}"

    echo -n "Setting a context entry in kubeconfig..."
        kubectl config set-context \
    "${SERVICE_ACCOUNT_NAME}-${NAMESPACE}-${CLUSTER_NAME}" \
    --kubeconfig="${KUBECFG_FILE_NAME}" \
    --cluster="${CLUSTER_NAME}" \
    --user="${SERVICE_ACCOUNT_NAME}-${NAMESPACE}-${CLUSTER_NAME}" \
    --namespace="${NAMESPACE}"

    echo -n "Setting the current-context in the kubeconfig file..."
    kubectl config use-context "${SERVICE_ACCOUNT_NAME}-${NAMESPACE}-${CLUSTER_NAME}" \
    --kubeconfig="${KUBECFG_FILE_NAME}"
}


CLIENT_VERSION=$(kubectl version --client | awk '/Client Version: /{print $3}'| cut -d '.' -f 2)
echo "$CLIENT_VERSION"
if [[ $CLIENT_VERSION -gt 27 ]]
then 
    VERSION=$(kubectl version | awk '/Server Version: /{print $3}' | cut -d '.' -f 2 )
    VERSION=$(expr $VERSION)
else
    VERSION=$(kubectl version --short | awk '/Server Version: /{print $3}' | cut -d '.' -f 2 )
    VERSION=$(expr $VERSION)
fi

if [[ $VERSION -ge 24 ]]
then
 create_target_folder
 create_cluster_role_binding
 create_service_account
 create_secret
 get_secret_name_from_secret
 extract_ca_crt_from_secret
 get_user_token_from_secret
 set_kube_config_values
else
 create_target_folder
 create_cluster_role_binding
 create_service_account
 get_secret_name_from_service_account
 extract_ca_crt_from_secret
 get_user_token_from_secret
 set_kube_config_values
fi 

echo -e "\\nAll done! Test with:"
echo "KUBECONFIG=${KUBECFG_FILE_NAME} kubectl get pods"
echo "you should not have any permissions by default - you have just created the authentication part"
echo "You will need to create RBAC permissions"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
echo "SERVER URL := ${SERVER_URL} "
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
echo "BEARER TOKEN := ${TOKEN} "
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "

KUBECONFIG=${KUBECFG_FILE_NAME} kubectl get pods
