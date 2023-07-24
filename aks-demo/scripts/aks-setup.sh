#/bin/bash
# version 1.0.0
# using service principal 

source ./config.sh

# Create Resource Group
echo "${GREEN} Creating Resource Group: ${RED} ${RG} ${NOCOLOR}"
az group create -l $LOCATION -n $RG

# Create ACR
echo "${GREEN} Creating Container Registry: ${RED} ${ACR} ${NOCOLOR}"
az acr create -n $ACR -g $RG --sku standard 

# Login to ACR 
az acr login --name $ACR 

# Create Service Principal 
sp_name=sp-aks-${RG}
SERVICE_PRINCIPAL=$(az ad sp create-for-rbac --skip-assignment --name ${sp_name})
echo "${GREEN} Creating Service Principal ${NOCOLOR}"

SERVICE_PRINCIPAL_ID=$(echo ${SERVICE_PRINCIPAL} | jq .appId -r) 
CLIENT_SECRET=$(echo ${SERVICE_PRINCIPAL} | jq .password -r) 

ACRID=$(az acr show -g $RG -n $ACR | jq .id )

# Now we assign a role with the created service principal create before
echo "${GREEN} Assigning Role to Service Principal"
az role assignment create --assignee $SERVICE_PRINCIPAL_ID --scope $ACRID --role Reader 

# Create the Azure Kubernetes Cluster 
echo "${GREEN} Creating Kubernetes Cluster: ${RED}${AKS}"
az aks create \
    --resource-group ${RG} \
    --location ${LOCATION} \
    --name ${AKS} \
    --service-principal ${SERVICE_PRINCIPAL_ID} \
    --client-secret ${CLIENT_SECRET} \
    --node-count 2 \
    --enable-addons monitoring \
    --generate-ssh-keys \
    --verbose
    
# Now we get the credentials 
echo "Saving Kubernetes Credentials to Host"
az aks get-credentials -g $RG -n $AKS

# Attaching ACR in our AKS
echo "Attaching ACR to AKS"
az aks update -n $AKS -g $RG --attach-acr $ACR

# Create Namespace
kubectl create namespace $NAMESPACE

# Create example Application
kubectl run test-server --image=gcr.io/google_containers/echoserver:1.8 -n $NAMESPACE
kubectl expose pod test-server --type=NodePort --port=80 --target-port=8080 -n $NAMESPACE
