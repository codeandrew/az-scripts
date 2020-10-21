# Azure CLI Scripts & Snippets 

## Logging in

If you enabled your MFA you must include your tenant id

az login --tenant [tenantid]

## Resourge Group
**Creating RG**
```
az group create -l westus -n MyResourceGroup

```

**Deleting RG**
```
az group delete -n MyResourceGroup
```

## Virtual Networks

Create a virtual network.

```
az network vnet create -g MyResourceGroup -n MyVnet
```


Create a virtual network with a specific address prefix and one subnet.
```
az network vnet create -g MyResourceGroup -n MyVnet --address-prefix 10.0.0.0/16 \
         --subnet-name MySubnet --subnet-prefix 10.0.0.0/24
```
## AKS

**NOTES**
Attach ACR to your AKS for more convience

```
az aks update -n myAKSCluster -g myResourceGroup --attach-acr $MYACR
```
### INGRESS Nginx

```bash
# Create a namespace for your ingress resources
kubectl create namespace ingress-basic

# Add the ingress-nginx repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

# Use Helm to deploy an NGINX ingress controller
helm install nginx-ingress ingress-nginx/ingress-nginx \
    --namespace ingress-basic \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.service.loadBalancerIP="STATIC_IP" \
    --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-dns-label-name"="DNS_LABEL"
```

## References 

### Moving Resources to another Subscription

https://medium.com/@calloncampbell/moving-your-azure-resources-to-another-subscription-or-resource-group-1644f43d2e07#:~:text=Step%201%20%E2%80%94%20Navigate%20to%20the,Move%20to%20another%20subscription%20option.

### AKS Ingress Static Ip

https://docs.microsoft.com/en-us/azure/aks/ingress-static-ip