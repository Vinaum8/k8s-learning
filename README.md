# k8s-learning
Desenvolvimento e registros dos estudos com K8s.

```
kubectl create secret docker-registry <name> `
  --docker-server=DOCKER_REGISTRY_SERVER `
  --docker-username=DOCKER_USER `
  --docker-password=DOCKER_PASSWORD `
  --docker-email=DOCKER_EMAIL
```

Cert Manager Notes:
Staging certificates are valid but not trusted by browsers so you must get a production replacement before putting your site live.

## Comandos úteis
```
* kubectl run --image alpine -it demo sh
```


## Powershell
Os comandos para inicializam do cluster com o start/powershell/start.ps1

## Bash
Em desenvolvimento

# Referências de estudos
> https://kubernetes.io/docs/concepts/containers/images/#using-a-private-registry

> https://cert-manager.io/docs/installation/helm/

> https://www.howtogeek.com/devops/how-to-install-kubernetes-cert-manager-and-configure-lets-encrypt/