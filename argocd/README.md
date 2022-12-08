## Install Argocd
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

## [Install](https://argo-cd.readthedocs.io/en/stable/cli_installation/) ArgoCD CLI
```bash
#For Example Homebrew
brew install argocd
```

## Expose Argo CD
Via LoadBalancer
```bash
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```
Or Port Forward
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

## Check your password
For this case your username `admin`
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

## Login Argocd
```bash
argocd login localhost
```

