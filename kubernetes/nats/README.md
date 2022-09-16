## Install Nats with Helm
```bash
helm repo add nats https://nats-io.github.io/k8s/helm/charts/
helm install nats nats/nats --values ./nats/values.yaml && kubectl apply -f ./nats/service-nats.yaml
```

## Use nats toolbox to test
```bash
kubectl exec -n default -it deployment/nats-box -- /bin/sh -l

  nats-box:~# nats-sub test &
  nats-box:~# nats-pub test hi
  nats-box:~# nc nats 4222
```