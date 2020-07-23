

## Install Docker and Git for Windows

## Prepare Application for Azure Kubernetes

https://github.com/Azure-Samples/azure-voting-app-redis.git

## Demo Create Azure Container Registry

Download az cli 

```az cli
az login 

$location = "Southeast Asia"
$rg= "az-demo-rg"

# Create RG 
az group create -n $rg  -l $location
# Create ACR 
az acr create --resource-group $rg -n AZDemoACR --sku basic 
# Login to ACR 
az acr login --name az-demo-acr 
az acr list

azdemoacr.azurecr.io

# retag your docker images and push it your ACR 

az acr repository list --name AZDemoACR

```

## Demo create Kubernetes Cluster

First Create Service Principal 

```
az ad sp create-for-rbac --skip-assignment
# get values 
# appId
# displayName
# name 
# password
# tenant 

```

Then get the acr id
```
az acr show --resource-group $rg --name AZDemoACR
# we get the ID from it and store it at $ACRID
```

Now we'll create a role
```
az role assignment create --assignee $appId --scope $ACRID --role Reader 
```

Now we create the Azure Kubernetes Cluster 
```
az aks create --resource-group $rg --name AZDemoAKS --node-count 1 \
     --service-principal $appId --client-secret $password \
     --generate-ssh-keys 

# appId from service principal command
# password from service principal command
```

Now install kubectl and get the credentials 
```
az aks install-cli # if you don't have kubectl 
az aks get-credentials --resource-group $rg --name AZDemoAKS 
```


## Demo Run Application on Kubernetes 
From the clone azure sample change the image name from your ACR 

kubectl apply -f .yaml 


Increase Node count of aks 

```
az aks scale --resource-group $rg --name azdemoaks --node-count 3
```


## Securing Container Registry

## Container Security: Azure Kubernetes Service 

## Container Scanning






