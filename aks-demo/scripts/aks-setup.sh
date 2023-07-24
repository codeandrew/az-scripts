#/bin/bash
# version 1.1.0
# using service principal 

source ./config.sh

# Create Resource Group
echo "Creating Resource Group: ${RG}"
az group create -l $LOCATION -n $RG

# Create ACR
echo "Creating Container Registry: ${ACR}"
az acr create -n $ACR -g $RG --sku standard 

# Login to ACR 
az acr login --name $ACR 

# Get the id of the ACR
ACRID=$(az acr show --name $ACR --query id --output tsv)

# Create the Azure Kubernetes Cluster with managed identity
echo "Creating Kubernetes Cluster: ${AKS}"
az aks create \
  --resource-group ${RG} \
  --location ${LOCATION} \
  --name ${AKS} \
  --node-count 2 \
  --enable-addons monitoring \
  --generate-ssh-keys \
  --enable-managed-identity \
  --verbose
    
# Now we get the credentials 
echo "Saving Kubernetes Credentials to Host"
az aks get-credentials -g $RG -n $AKS

# Attach ACR to AKS
echo "Attaching ACR to AKS"
az aks update -n $AKS -g $RG --attach-acr $ACR

# Create Namespace
kubectl create namespace $NAMESPACE

# Create example Application
kubectl run test-server --image=gcr.io/google_containers/echoserver:1.8 -n $NAMESPACE
kubectl expose pod test-server --type=NodePort --port=80 --target-port=8080 -n $NAMESPACE

