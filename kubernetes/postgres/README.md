## Setup Things DB
```bash
helm template things-db postgres --values ./postgres/things-db.values.yaml
helm install things-db postgres --values ./postgres/things-db.values.yaml
# Test
kubectl exec -it things-db-0 -- psql -h localhost -U Vechr -p 5432 things_db
```

## Setup Notification DB
```bash
helm template notification-db postgres --values ./postgres/notification-db.values.yaml
helm install notification-db postgres --values ./postgres/notification-db.values.yaml
#Test
kubectl exec -it notification-db-0 -- psql -h localhost -U Vechr -p 5432 notification_db
```