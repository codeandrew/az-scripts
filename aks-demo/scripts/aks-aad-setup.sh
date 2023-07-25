#!/bin/bash

source ./config.sh

set -x
# AKS Cluster Details
aks_cluster_name=$AKS
resource_group_name=$RG
aad_admin_group_id=$(az ad signed-in-user show --query id --output tsv)

# Service Account Details
service_account_name="dashboard-sa"

# Step 1: Enable Azure AD integration for your AKS cluster
az aks update --name $aks_cluster_name \
              --resource-group $resource_group_name \
              --enable-aad \
              --aad-admin-group-object-ids $aad_admin_group_id

# Step 2: Create a Kubernetes service account and an Azure AD application
kubectl create serviceaccount $service_account_name

# Step 3: Assign the necessary RBAC roles to the service account
kubectl create clusterrolebinding $service_account_name-cluster-admin-binding \
                                  --clusterrole=cluster-admin \
                                  --serviceaccount=default:$service_account_name

# Step 4: Deploy the Kubernetes dashboard using the service account
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.4.0/aio/deploy/recommended.yaml

# Get the token for the service account
service_account_secret_name=$(kubectl get serviceaccount $service_account_name -o jsonpath='{.secrets[0].name}')
service_account_token=$(kubectl get secret $service_account_secret_name -o jsonpath='{.data.token}' | base64 --decode)

echo "Kubernetes dashboard is deployed and accessible at:"
echo "http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"
echo "Use the following token for authentication:"
echo $service_account_token
echo "or use your kube config at $USER/.kube/config"

# Start kubectl proxy to access the dashboard
kubectl proxy
