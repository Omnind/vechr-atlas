ENV file on Docker file

## Application
```bash
# Review Chart
helm template web-app fe --values ./fe/values.yaml

# Install Chart
helm install web-app fe --values ./fe/values.yaml
````