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


## References 

### Moving Resources to another Subscription

https://medium.com/@calloncampbell/moving-your-azure-resources-to-another-subscription-or-resource-group-1644f43d2e07#:~:text=Step%201%20%E2%80%94%20Navigate%20to%20the,Move%20to%20another%20subscription%20option.

