#!/bin/sh

source ./config.sh

az group create -l $LOCATION -n $RG
az network vnet create -g $RG -n $VNET

az network vnet create -g $RG -n $VNET --address-prefix 10.0.0.0/16 \
      --subnet-name $SUBNET-0 --subnet-prefix 10.0.0.0/24
