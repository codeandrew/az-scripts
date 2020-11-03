#!/bin/bash
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

echo "${GREEN} Creating Public IP ${NOCOLOR}"
az network public-ip create -n $NAME-ip-0\
  -g $RG -l $LOCATION \
  --allocation-method dynamic

echo "${GREEN} Attaching DNS ${NOCOLOR}"
az network public-ip update -n $NAME-ip-0\
  -g $RG --dns-name $DNS 

echo "${GREEN} Creating Network Interface: ${RED} ${NAME}-nic ${NOCOLOR}"
az network nic create -g $RG \
  -n $NAME-nic --vnet-name $VNET \
  --subnet $SUBNET-0 \
  --network-security-group $NSG \
  --public-ip-address $NAME-ip-0

echo "${GREEN} Creating Virtual Machine: ${RED} ${VM} ${NOCOLOR}"
echo "Operating System: Ubuntu"
az vm create -n $VM -g $RG --image UbuntuLTS \
    --nics $NAME-nic \
    --data-disk-sizes-gb 10 20 \
    --size Standard_DS2_v2 \
    --admin-username azureuser \
    --generate-ssh-keys

# When specifying an existing NIC, do not specify NSG, public IP, ASGs, VNet or subnet.
# The --generate-ssh-keys parameter is used to automatically generate an SSH key, and put it in the default key location (~/.ssh).
# https://docs.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-cli



