#/bin/bash
# Source VARIABLES
source ./config.sh

# Check Resource Provider registration
namespace='Microsoft.ContainerService'
if [ "$(az provider show --namespace ${namespace} | jq -r .registrationState)" != 'Registered' ]
then
      az provider register --namespace ${namespace} --verbose
else
      echo "Namespace \"${namespace}\" is already registered."
fi

# Create Resource Group
echo "${GREEN} Creating Resource Group: ${RED} ${RG} ${NOCOLOR}"
az group create -l $LOCATION -n $RG

# Deploy Log Analytics Workspace
solution='logAnalytics'
template_path='../arm'
template_file="${template_path}/${solution}/azureDeploy.json"

set -x
timestamp=$(date -u +%FT%TZ | tr -dc '[:alnum:]\n\r')
name="${RG}-${timestamp}"
deployment=$(az group deployment create --resource-group ${RG} --name ${name} --template-file ${template_file} --verbose)

# Create Service Principal
sp_name=sp-aks-${RG}
sp=$(az ad sp create-for-rbac --name ${sp_name})

logAnalyticsId=$(echo $deployment | jq .properties.outputs.workspaceResourceId.value -r)

SERVICE_PRINCIPAL_ID=$(echo $sp | jq .appId -r) 
CLIENT_SECRET=$(echo $sp | jq .password -r) 

# Create ACR
echo "${GREEN} Creating Container Registry: ${RED} ${ACR} ${NOCOLOR}"
ACR_OUTPUT=$(az acr create -n $ACR -g $RG --sku standard)

ACRID=$(eval(echo $ACR_OUTPUT | jq .id ))

# Now we assign a role with the created service principal create before
echo "${GREEN} Assigning Role to Service Principal"
az role assignment create --assignee $SERVICE_PRINCIPAL_ID --scope $ACRID --role Reader 

logAnalyticsId=$(echo $deployment | jq .properties.outputs.workspaceResourceId.value -r)

# Deploy AKS Cluster
echo "${GREEN} Creating Kubernetes Cluster: ${RED}${AKS} ${NOCOLOR}"
az aks create \
    --resource-group ${RG} \
    --location ${LOCATION} \
    --name ${AKS} \
    --service-principal ${SERVICE_PRINCIPAL_ID} \
    --client-secret ${CLIENT_SECRET} \
    --node-count 2 \
#     --node-vm-size Standard_DS1_v2 \
    --enable-addons monitoring \
    --generate-ssh-keys \
    --workspace-resource-id ${logAnalyticsId} \
    --disable-rbac \
    --verbose

# Now we get the credentials 
echo "Saving Kubernetes Credentials to Host"
az aks get-credentials -g $RG -n $AKS

# Attaching ACR in our AKS
echo "Attaching ACR to AKS"
az aks update -n $AKS -g $RG --attach-acr $ACR