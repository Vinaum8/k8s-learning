# Requisitos
* Helm
* Git

# Getting the Chart Sources
```git clone https://github.com/nginxinc/kubernetes-ingress.git --branch v2.4.0
cd kubernetes-ingress/deployments/helm-chart
```

``` 
git clone https://github.com/kubernetes/ingress-nginx.git
cd 
```

# Install Nginx With Helm
```
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
```

``` 
helm install nginx-ingress nginx-stable/nginx-ingress \
    --namespace ingress-nginx \
    --create-namespace \
    --set controller.metrics.enabled=true \
    --set-string controller.podAnnotations."prometheus\.io/scrape"="true" \
    --set-string controller.podAnnotations."prometheus\.io/port"="10254"
```

```
helm get values nginx-ingress --namespace ingress-nginx
```

# Install Prometheus Stack with Helm
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
```

```
helm install prometheus prometheus-community/kube-prometheus-stack \
--namespace prometheus \
--create-namespace
```

```
kubectl port-forward deployment/prometheus-grafana 3000
```

# Update Nginx with Prometheus

```
helm upgrade nginx-ingress nginx-stable/nginx-ingress \
--namespace ingress-nginx \
--set controller.metrics.enabled=true \
--set controller.metrics.serviceMonitor.enabled=true \
--set-string controller.metrics.serviceMonitor.additionalLabels.release="prometheus" \
--set-string controller.podAnnotations."prometheus\.io/scrape"="true" \
--set-string controller.podAnnotations."prometheus\.io/port"="10254"


helm upgrade ingress-nginx ingress-nginx/ingress-nginx \
--namespace ingress-nginx \
--set controller.metrics.enabled=true \
--set controller.metrics.serviceMonitor.enabled=true \
--set controller.metrics.serviceMonitor.additionalLabels.release="prometheus"
```

```
helm get values nginx-ingress -n ingress-nginx
```

# Update Prometheus with others Namespaces

```
helm upgrade prometheus prometheus-community/kube-prometheus-stack \
--namespace prometheus  \
--set prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues=false \
--set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false
```

## Comandos para checagem:

kubectl get pods -l "release=prometheus" --all-namespaces
kubectl get pods -n ingress-nginx --show-labels

# O que faltou?
- Mudar o nome da release no helm
- Adicionar o label nos pods do NGINX via HELM.
- Ou adicionar o match label no prometheus via helm

# Reference
https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-helm/#installing-the-crds

https://kubernetes.github.io/ingress-nginx/user-guide/monitoring/

https://github.com/kubernetes/ingress-nginx/blob/main/docs/deploy/index.md

https://k21academy.com/docker-kubernetes/prometheus-grafana-monitoring/

https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack