
# https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm repo update

kubectl create namespace monitoring
helm install prometheus prometheus-community/prometheus --namespace monitoring --set rbac.create=true