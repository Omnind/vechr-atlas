# Kong Gateway

## Install Kong Gateway
```bash
kubectl create -f https://bit.ly/k4k8s
kubectl -n kong get service kong-proxy
```


## Delete Kong Gateway
```bash
kubectl delete -f https://bit.ly/k4k8s
```

## Deploy API
```bash
kubectl apply -f ./kong/things-ingress.yaml
kubectl delete -f ./kong/things-ingress.yaml


kubectl apply -f ./kong/notification-ingress.yaml
kubectl delete -f ./kong/notification-ingress.yaml

kubectl apply -f ./kong/fe-ingress.yaml
kubectl delete -f ./kong/fe-ingress.yaml
```

## Using Helm
```bash
kubectl create namespace kong
helm install kong -n kong kong/kong
kubectl -n kong get all
helm -n kong list
helm show values kong/kong > values-default.yaml
get crds -n kong | grep kong


helm upgrade kong -n kong kong/kong -f kong/values.yaml
```