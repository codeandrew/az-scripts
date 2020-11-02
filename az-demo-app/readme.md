# AZ AKS Demo Application

Contents
- Setting up AKS
- Ingress
    - Public Ip
    - DNS
- Cert Manager
- Create CA Cluster Issuer


## Procedures

### Azure Kubernetes Cluster

make sure to edit variables in `config.sh`

```bash
./az-aks.sh
```

### Install Cert Manager

Before certificates can be issued, cert-manager requires an Issuer or ClusterIssuer resource. These Kubernetes resources are identical in functionality, however Issuer works in a single namespace, and ClusterIssuer works across all namespaces

```bash
# Install Helm Cert Manager
./install-certmanager.sh
kubectl apply -f cluster-issuer.yaml
```

### Applications

```bash
kubectl apply -f aks-helloworld-one.yaml --namespace demo
kubectl apply -f aks-helloworld-two.yaml --namespace demo
```

### Ingress Route

Both applications are now running on your Kubernetes cluster. However they're configured with a service of type ClusterIP and aren't accessible from the internet. To make them publicly available, create a Kubernetes ingress resource. The ingress resource configures the rules that route traffic to one of the two applications.

In the following example, traffic to the address hello-world-ingress.MY_CUSTOM_DOMAIN is routed to the aks-helloworld service. Traffic to the address hello-world-ingress.MY_CUSTOM_DOMAIN/hello-world-two is routed to the aks-helloworld-two service. Traffic to hello-world-ingress.MY_CUSTOM_DOMAIN/static is routed to the service named aks-helloworld for static assets.

`hello-world-ingress.yaml`

**NOTE**
>If you configured an FQDN for the ingress controller IP address instead of a custom domain, use the FQDN instead of hello-world-ingress.MY_CUSTOM_DOMAIN. For example if your FQDN is demo-aks-ingress.eastus.cloudapp.azure.com, replace hello-world-ingress.MY_CUSTOM_DOMAIN with demo-aks-ingress.eastus.cloudapp.azure.com in hello-world-ingress.yaml.

```bash
kubectl apply -f hello-world-ingress.yaml --namespace demo
```

### Verify Certificate if Created
Verify a certificate object has been created

```bash
$ kubectl get certificate --namespace demo

NAME         READY   SECRET       AGE
tls-secret   True    tls-secret   11m
```

TLS will take several minutes so you can check here
```bash
kubectl describe certificate tls-secret -n demo
```

## References
