# Permissão de executar scripts no windows
Set-ExecutionPolicy Unrestricted

# Install chocolatey on Windows
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Instalar pré requisitos para criação de um cluster local
choco install kind --force -y
choco install kubernetes-cli -y
choco install docker -y
choco install docker-desktop -y
choco install git -y
choco install kubernetes-helm -y

kind create cluster --config .\kind\kind-start-config.yaml

kubectl cluster-info --context kind-k8s-learning

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

kubectl wait --namespace ingress-nginx `
  --for=condition=ready pod `
  --selector=app.kubernetes.io/component=controller `
  --timeout=90s

kubectl apply -f .\deploy-app\deployment.yaml

Write-Output "Acesse os links no navegador para validar o funcionamento do cluster com Nginx - Ingress"
Write-Output "http://localhost/bar"
Write-Output "http://localhost/foo"

