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