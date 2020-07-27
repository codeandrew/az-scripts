#!/bin/bash

source ./config.sh 

REGISTRY=$ACR.azurecr.io
echo "Enter docker image"
read IMAGE

echo "Enter new tag version"
read VERSION

NEW_IMAGE=$REGISTRY/$IMAGE:$VERSION
docker tag $IMAGE $NEW_IMAGE
docker push $NEW_IMAGE

$NEW_IMAGE >> az-images.list
echo $NEW_IMAGE


