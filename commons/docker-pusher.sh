#!/bin/bash

source ./config.sh 

REGISTRY=$ACR.azurecr.io
echo "Enter docker image"
read IMAGE

NEW_IMAGE=$REGISTRY/$IMAGE
docker tag $IMAGE $NEW_IMAGE
docker push $NEW_IMAGE

echo $NEW_IMAGE >> az-images.list
echo $NEW_IMAGE


