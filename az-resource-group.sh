#!/bin/sh

source ./config.sh

# Create Resource Group
echo "${GREEN} Creating Resource Group: ${RED} ${RG} ${NOCOLOR}"
az group create -l $LOCATION -n $RG

# Create VNET with subnet
echo "${GREEN} Creating Virtual Network: ${RED} ${VNET} $NOCOLOR"
az network vnet create -g $RG -n $VNET --address-prefix 10.0.0.0/16 \
      --subnet-name $SUBNET-0 --subnet-prefix 10.0.0.0/24

# Create NSG
echo "${GREEN} Creating Network Security Group: ${RED} ${NSG} ${NOCOLOR}"
az network nsg create -g $RG \
  -n $NSG \
  --tags no_80 no_22 nsg

# NSG RULE SSH
az network nsg rule create -g $RG \
    -n ALLOW_SSH \
    --access allow \
    --destination-address-prefix '*' \
    --destination-port-range 22 \
    --direction inbound \
    --nsg-name $NSG \
    --protocol tcp \
    --source-address-prefix '*' \
    --source-port-range '*' \
    --priority 1000

# NSG RULE Website and SSL
az network nsg rule create -g $RG \
    -n ALLOW_WEBSITE_SSL \
    --access allow \
    --destination-address-prefix '*' \
    --destination-port-range 80 443 \
    --direction inbound \
    --nsg-name $NSG \
    --protocol '*' \
    --source-address-prefix '*' \
    --source-port-range '*' \
    --priority 1010

# Create ACR
echo "${GREEN} Creating Container Registry: ${RED} ${ACR} ${NOCOLOR}"
az acr create -n $ACR -g $RG --sku basic 

# Login to ACR 
az acr login --name $ACR 

# Create Service Principal 
SERVICE_PRINCIPAL=$(az ad sp create-for-rbac --skip-assignment)
echo "${GREEN} Creating Service Principal ${NOCOLOR}"
echo $SERVICE_PRINCIPAL > service_principal.txt 

jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' service_principal.txt > service_principal.env 
echo "This is your Service Principal Get all values, Assign later"
cat service_principal.env 

ID=$(az acr show -g $RG -n $ACR | jq .id )
echo "ACRID=$ID" >> service_principal.env




