#!/bin/sh
source ./config.sh 

# First get the resource group name of the AKS cluster
AKS_RG=$(az aks show --resource-group $RG \
    --name $AKS \
    --query nodeResourceGroup \
    -o tsv)

# Create Public IP
IP=$(az network public-ip create \
    --resource-group $AKS_RG \
    --name $PUBIP \
    --sku Standard \
    --allocation-method static \
    --query publicIp.ipAddress \
    -o tsv )

# Name to associate with public IP address
DNSNAME=$NAME

# Get the resource-id of the public ip
PUBLICIPID=$(az network public-ip list --query "[?ipAddress!=null]|[?contains(ipAddress, '$IP')].[id]" --output tsv)

# Update public ip address with DNS name
az network public-ip update --ids $PUBLICIPID --dns-name $DNSNAME

# Display the FQDN
az network public-ip show --ids $PUBLICIPID --query "[dnsSettings.fqdn]" --output  tsv

# Create a namespace for your ingress resources
kubectl create namespace ingress

# Add the ingress-nginx repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

NEW_PUBLIC_IP=$IP
NEW_DNS=$DNSNAME

# Use Helm to deploy an NGINX ingress controller
helm install nginx-ingress ingress-nginx/ingress-nginx \
    --namespace ingress \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.service.loadBalancerIP="$NEW_PUBLIC_IP" \
    --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-dns-label-name"="$NAME"


# For Checking External IP Pending
kubectl --namespace ingress get services -o wide -w nginx-ingress-ingress-nginx-controller

# Check DNS Label if working
az network public-ip list \
    --resource-group $AKS_RG \
    --query "[?name=='$PUBIP'].[dnsSettings.fqdn]" \
    -o tsv