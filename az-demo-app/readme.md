# AZ AKS Demo Application

Contents
- Setting up AKS
- Ingress
    - Public Ip
    - DNS
- Cert Manager
- Create CA Cluster Issuer


## Procedures

### Install Cert Manager

```bash
# Install Helm Cert Manager
./install-certmanager.sh
kubectl apply -f cluster-issuer.yaml

```


