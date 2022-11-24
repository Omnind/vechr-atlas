#!/bin/bash

# Setup posgres
helm install things-db postgres --values ./postgres/things-db.values.yaml \
  && helm install notification-db postgres --values ./postgres/notification-db.values.yaml \
  && helm install auth-db postgres --values ./postgres/auth-db.values.yaml \
  && helm install audit-db postgres --values ./postgres/audit-db.values.yaml \
  && helm install influxdb influx --values ./influx/values.yaml \
  && kubectl apply -f ./mail/gmail-external-service.yaml \
  && helm repo add nats https://nats-io.github.io/k8s/helm/charts/ \
  && helm install nats nats/nats --values ./nats/values.yaml \
  && kubectl apply -f ./nats/service-nats.yaml \
  && helm install things-service service --values ./service/things-service.values.yaml \
  && helm install notification-service service --values ./service/notification-service.values.yaml \
  && helm install db-logger-service service --values ./service/db-logger-service.values.yaml \
  && helm install auth-service service --values ./service/auth-service.values.yaml \
  && helm install audit-service service --values ./service/audit-service.values.yaml \
  && helm install web-app fe --values ./fe/values.yaml \
  && kubectl create namespace kong \
  && helm install kong -n kong kong/kong -f kong/values.yaml \
  && kubectl apply -f ./kong/things-ingress.yaml \
  && kubectl apply -f ./kong/notification-ingress.yaml \
  && kubectl apply -f ./kong/auth-ingress.yaml \
  && kubectl apply -f ./kong/audit-ingress.yaml \
  && kubectl apply -f ./kong/fe-ingress.yaml