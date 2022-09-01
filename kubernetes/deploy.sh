#!/bin/bash

# Setup posgres
helm install things-db postgres --values ./postgres/things-db.values.yaml \
  && helm install notification-db postgres --values ./postgres/notification-db.values.yaml \
  && helm install influxdb influx --values ./influx/values.yaml \
  && kubectl apply -f ./mail/gmail-external-service.yaml \
  && helm repo add nats https://nats-io.github.io/k8s/helm/charts/ \
  && helm install nats nats/nats --values ./nats/values.yaml \
  && kubectl apply -f ./nats/service-nats.yaml \
  && helm install things-service service --values ./service/things-service.values.yaml \
  && helm install notification-service service --values ./service/notification-service.values.yaml \
  && helm install db-logger-service service --values ./service/db-logger-service.values.yaml