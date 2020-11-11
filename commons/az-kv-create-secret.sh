#!/bin/bash
source ./config.sh

VAULT_NAME=$NAME-kv

export ENV=$(cat ./env)
echo $ENV

for env in ${ENV[@]};do
  echo ------------------
  val=(${env//=/ })
  echo ${val[0]}
  echo ${val[1]}
  az keyvault secret set \
    --vault-name $VAULT_NAME \
    --name "${val[0]}" \
    --value "${val[1]}"
done
