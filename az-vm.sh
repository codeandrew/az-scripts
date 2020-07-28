#!/bin/bash

source ./config.sh

echo "${GREEN} Creating Public IP ${NOCOLOR}"
az network public-ip create -n $NAME-ip-0\
  -g $RG -l $LOCATION \
  --allocation-method dynamic

echo "${GREEN} Creating Network Interface: ${RED} ${NAME}-nic ${NOCOLOR}"
az network nic create -g $RG \
  -n $NAME-nic --vnet-name $VNET \
  --subnet $SUBNET-0 \
  --public-ip-address $NAME-ip-0

echo "${GREEN} Creating Virtual Machine: ${RED} ${VM} ${NOCOLOR}"
echo "Operating System: Ubuntu"
az vm create -n $VM -g $RG --image UbuntuLTS \
    --nics $NAME-nic \
    --data-disk-sizes-gb 10 20 \
    --size Standard_DS2_v2
# When specifying an existing NIC, do not specify NSG, public IP, ASGs, VNet or subnet.


