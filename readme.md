# Azure CLI Scripts & Snippets 

## Logging in

If you enabled your MFA you must include your tenant id

az login --tenant [tenantid]

## Troubleshooting 

Common troubleshooting problems

### AKS 

```bash
kubectl get events --all-namespaces
```

## References 

### Moving Resources to another Subscription

https://medium.com/@calloncampbell/moving-your-azure-resources-to-another-subscription-or-resource-group-1644f43d2e07#:~:text=Step%201%20%E2%80%94%20Navigate%20to%20the,Move%20to%20another%20subscription%20option.

### AKS Ingress Static Ip

https://docs.microsoft.com/en-us/azure/aks/ingress-static-ip