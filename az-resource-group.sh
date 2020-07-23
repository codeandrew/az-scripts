#!/bin/sh

source ./config.sh

# Create Resource Group
az group create -l $LOCATION -n $RG

# Create VNET with subnet
az network vnet create -g $RG -n $VNET --address-prefix 10.0.0.0/16 \
      --subnet-name $SUBNET-0 --subnet-prefix 10.0.0.0/24

# Create NSG
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

# Create ACR
az acr create $RG -n AZDemoACR --sku basic 

# Login to ACR 
az acr login --name az-demo-acr 

az acr list

# azdemoacr.azurecr.io

# Create Service Principal 
az ad sp create-for-rbac --skip-assignment

echo "Get all Values"
echo  "appId,  displayName,  name, password, tenant "
