# AKS Demo Application

## Procedures

Make sure to follow this in order

```bash
# Go to Scripts Folder
cd scripts

# First edit the variable names
./config.sh

# This will setup the Azure Kubernetes Service
./aks-setup.sh 

# This will create Public IP and DNS zone
./ip-dns.sh

# This will setup ingress load balancer
./ingress-setup.sh


```

## Notes

### Ingress Route

Both applications are now running on your Kubernetes cluster. However they're configured with a service of type ClusterIP and aren't accessible from the internet. To make them publicly available, create a Kubernetes ingress resource. The ingress resource configures the rules that route traffic to one of the two applications.

In the following example, traffic to the address hello-world-ingress.MY_CUSTOM_DOMAIN is routed to the aks-helloworld service. Traffic to the address hello-world-ingress.MY_CUSTOM_DOMAIN/hello-world-two is routed to the aks-helloworld-two service. Traffic to hello-world-ingress.MY_CUSTOM_DOMAIN/static is routed to the service named aks-helloworld for static assets.

`demo-ingress.yaml`

**NOTE**
>If you configured an FQDN for the ingress controller IP address instead of a custom domain, use the FQDN instead of hello-world-ingress.MY_CUSTOM_DOMAIN. For example if your FQDN is demo-aks-ingress.eastus.cloudapp.azure.com, replace hello-world-ingress.MY_CUSTOM_DOMAIN with demo-aks-ingress.eastus.cloudapp.azure.com in hello-world-ingress.yaml.

```bash
kubectl apply -f demo-ingress.yaml --namespace demo
```

### Verify Certificate if Created
Verify a certificate object has been created

```bash
$ kubectl get certificate --namespace app

NAME         READY   SECRET       AGE
tls-secret   True    tls-secret   11m
```

TLS will take several minutes so you can check here
```bash
kubectl describe certificate tls-secret -n app
```

## References
