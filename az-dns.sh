#!/bin/bash

source ./config.sh

# Create DNS zone
az network dns zone create \
    -g $RG -n $DNS

# Create DNS record
az network dns record-set a add-record \
    -g $RG \
    -z $DNS \
    -n www \
    -a 10.10.10.10

# View Records
az network dns record-set list \
    -g $RG \
    -z $DNS

## REFERENCE
# https://docs.microsoft.com/en-us/azure/aks/ingress-tls

# Public IP address of your ingress controller
# Get tne Public IP inside the AKS cluster RG
# example : MC_az-jaf-demo-rg_az-jaf-demo-aks_southeastasia
IP=20.195.48.181

# Name to associate with public IP address
DNSNAME="azjafdemoaks"

# Get the resource-id of the public ip
PUBLICIPID=$(az network public-ip list --query "[?ipAddress!=null]|[?contains(ipAddress, '$IP')].[id]" --output tsv)

# Update public ip address with DNS name
az network public-ip update --ids $PUBLICIPID --dns-name $DNSNAME

# Display the FQDN
az network public-ip show --ids $PUBLICIPID --query "[dnsSettings.fqdn]" --output  tsv