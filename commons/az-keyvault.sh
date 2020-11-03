#!/bin/bash
source ./config.sh

az keyvault create -n $NAME-kv -g $RG -l $REGION
