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


