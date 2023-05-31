# Instalar pré requisitos para criação de um cluster local
#!/bin/bash

# Instalação do Kind
if ! command -v kind &> /dev/null; then
    echo "Instalando Kind..."
    # For AMD64 / x86_64
    [ $(uname -m) = x86_64 ] && curl -Lo /tmp/kind https://kind.sigs.k8s.io/dl/v0.19.0/kind-linux-amd64
    # For ARM64
    [ $(uname -m) = aarch64 ] && curl -Lo /tmp/kind https://kind.sigs.k8s.io/dl/v0.19.0/kind-linux-arm64
    chmod +x /tmp/kind
    sudo mv /tmp/kind /usr/local/bin/kind
else
    echo "Kind já está instalado."
fi

# Instalação do Docker
if ! command -v docker &> /dev/null; then
    echo "Instalando Docker..."
    
    sudo apt-get update
    sudo apt-get install ca-certificates curl gnupg -y

    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh ./get-docker.sh
else
    echo "Docker já está instalado."
fi

kind create cluster --config ./kind/kind-start-config.yaml

kubectl cluster-info --context kind-k8s-learning

# Deploy Ingress Nginx for Kind
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/usage.yaml

# should output "foo-app"
curl localhost/foo/hostname
# should output "bar-app"
curl localhost/bar/hostname