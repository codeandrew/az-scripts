# AKS Demo Application

## Procedures

Make sure to follow this in order

```bash
# First edit the variable names
./scripts/config.sh

# This will setup the Azure Kubernetes Service
# This will also create a test server with pod and service
./scripts/aks-setup.sh 

# This will setup ingress load balancer
./scripts/ingress-setup.sh

# This will setup Cluster Issuer for TLS
./scripts/install-certmanager.sh

# Create Helm Template for TLS 
helm template ./chart-tls --values ./chart-tls/values.yaml > tls-template.yaml
kubectl apply -f tls-template.yaml -n app --validate=false

## Create Helm Template for Application and Ingress 
helm template ./chart-app --values ./chart-app/values.yaml > app-template.yaml
kubectl apply -f app-template.yaml -n app

```

## Notes

### Ingress Route

Both applications are now running on your Kubernetes cluster. However they're configured with a service of type ClusterIP and aren't accessible from the internet. To make them publicly available, create a Kubernetes ingress resource. The ingress resource configures the rules that route traffic to one of the two applications.

**NOTE**
>If you configured an FQDN for the ingress controller IP address instead of a custom domain, use the FQDN instead of hello-world-ingress.MY_CUSTOM_DOMAIN. For example if your FQDN is demo-aks-ingress.eastus.cloudapp.azure.com, replace hello-world-ingress.MY_CUSTOM_DOMAIN with demo-aks-ingress.eastus.cloudapp.azure.com in hello-world-ingress.yaml.

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
