## Things Service
```bash
# Review Chart
helm template things-service service --values ./service/things-service.values.yaml

# Install Chart
helm install things-service service --values ./service/things-service.values.yaml
```

## Notification Service
```bash
# Review Chart
helm template notification-service service --values ./service/notification-service.values.yaml

# Install Chart
helm install notification-service service --values ./service/notification-service.values.yaml
```

## DB Logger Service
```bash
# Review Chart
helm template db-logger-service service --values ./service/db-logger-service.values.yaml

# Install Chart
helm install db-logger-service service --values ./service/db-logger-service.values.yaml
```