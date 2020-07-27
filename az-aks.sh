#/bin/bash

source ./config.sh
source ./service_principal.env

# Now we assign a role with the created service principal create before
echo "${GREEN} Assigning Role to Service Principal"
az role assignment create --assignee $appId --scope $ACRID --role Reader 

# Create the Azure Kubernetes Cluster 
echo "${GREEN} Creating Kubernetes Cluster: ${RED}${AKS}"
az aks create -g $RG -n $AKS --node-count 1 \
     --service-principal $appId --client-secret $password \
     --generate-ssh-keys > aks.log

cat aks.log

# Now we get the credentials 
echo "Saving Kubernetes Credentials to Host"
az aks get-credentials -g $RG -n $AKS