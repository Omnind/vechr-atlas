#!/bin/bash

# Service
curl -X POST http://localhost:8001/services \
  -H "Content-Type: application/json" \
  -d '{"name": "notification-service", "host": "host.docker.internal", "port": 3004, "path": "/api/v1/notification"}'

curl -X POST http://localhost:8001/services \
  -H "Content-Type: application/json" \
  -d '{"name": "notification-openapi", "host": "host.docker.internal", "port": 3004, "path": "/api/notification"}'


# Route
curl -X POST http://localhost:8001/services/notification-service/routes/ \
  -H "Content-Type: application/json" \
  -d '{"name": "notification-route", "paths": [ "/api/v1/notification" ], "protocols": [ "http", "https" ], "methods": [ "GET", "PUT", "PATCH", "POST", "DELETE" ]}'

curl -X POST http://localhost:8001/services/notification-openapi/routes/ \
  -H "Content-Type: application/json" \
  -d '{"name": "notification-route-openapi", "paths": [ "/docs/v1/notification", "/docs/notification" ], "protocols": [ "http", "https" ], "methods": [ "GET", "PUT", "PATCH", "POST", "DELETE" ]}'