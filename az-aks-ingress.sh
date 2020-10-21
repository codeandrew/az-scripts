#!/bin/sh

source ./config.sh 

# az aks show --resource-group $RG \
#     --name $AKS \
#     --query nodeResourceGroup \
#     -o tsv

# read -p 'wait till ok' OK
# echo $OK

# az network public-ip create \
#     --resource-group MC_az-jaf-demo-rg_az-jaf-demo-aks_southeastasia \
#     --name $PUBIP \
#     --sku Standard \
#     --allocation-method static \
#     --query publicIp.ipAddress \
#     -o tsv

# # Create a namespace for your ingress resources
# kubectl create namespace ingress-basic

# # Add the ingress-nginx repository
# helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

read -p 'Your Public IP Address for Azure Portal: ' NEW_PUBLIC_IP
read -p 'Your DNS: ' NEW_DNS

# Use Helm to deploy an NGINX ingress controller
helm install nginx-ingress ingress-nginx/ingress-nginx \
    --namespace ingress-basic \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.service.loadBalancerIP="$NEW_PUBLIC_IP" \
    --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-dns-label-name"="$NEW_DNS"


# For CHECKING
kubectl --namespace ingress-basic get services -o wide -w nginx-ingress-ingress-nginx-controller
