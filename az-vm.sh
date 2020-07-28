#!/bin/bash

source ./config.sh

az network public-ip create -n $NAME-ip-0\
  -g $RG -l $LOCATION \
  --allocation-method dynamic

az network nic create -g $RG \
  -n $NAME-nic --vnet-name $VNET \
  --subnet $SUBNET-0 \
  --public-ip-address $NAME-ip-0

az vm create -n $VM -g $RG --image UbuntuLTS \
    --nics $NAME-nic
    --vnet-name $VNET \
    --subnet $SUBNET-0 \
    --data-disk-sizes-gb 10 20 \
    --size Standard_DS2_v2


