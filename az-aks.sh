#/bin/bash

source ./config.sh
source ./service_principal.env

# Now we assign a role with the created service principal create before
az role assignment create --assignee $appId --scope $ACRID --role Reader 

# Create the Azure Kubernetes Cluster 
az aks create -g $RG -n $AKS --node-count 1 \
     --service-principal $appId --client-secret $password \
     --generate-ssh-keys 

# Now we get the credentials 
az aks install-cli # if you don't have kubectl
AKS_CRED=$(az aks get-credentials -g $RG -n $AKS)

echo $AKS_CRED > aks_credentials.txt
