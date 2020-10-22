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