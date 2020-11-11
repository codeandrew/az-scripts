#!/bin/bash
source ./config.sh

VAULT_NAME=$NAME-kv

az keyvault create -n $VAULT_NAME -g $RG -l $REGION

az keyvault secret set \
  --vault-name $VAULT_NAME \
  --name "ExamplePassword" \
  --value "hVFkk965BuUv"