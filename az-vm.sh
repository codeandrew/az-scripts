#!/bin/bash

source ./config.sh

az vm create -n $VM -g $RG --image UbuntuLTS \
    --public-ip-address "" \
    --vnet-name $VNET \
    --subnet $SUBNET-0 \
    --data-disk-sizes-gb 10 20 \
    --size Standard_DS2_v2


