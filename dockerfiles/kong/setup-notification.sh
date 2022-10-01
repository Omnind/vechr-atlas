#!/bin/bash

# Service
curl -X POST http://localhost:8001/services \
  -H "Content-Type: application/json" \
  -d '{"name": "notification-service-v1", "host": "host.docker.internal", "port": 3004, "path": "/api/v1/notification"}'

curl -X POST http://localhost:8001/services \
  -H "Content-Type: application/json" \
  -d '{"name": "notification-service-v2", "host": "host.docker.internal", "port": 3004, "path": "/api/v2/notification"}'

curl -X POST http://localhost:8001/services \
  -H "Content-Type: application/json" \
  -d '{"name": "notification-public", "host": "host.docker.internal", "port": 3004, "path": "/api/notification/public"}'

curl -X POST http://localhost:8001/services \
  -H "Content-Type: application/json" \
  -d '{"name": "notification-openapi", "host": "host.docker.internal", "port": 3004, "path": "/api/notification"}'


# Route
curl -X POST http://localhost:8001/services/notification-service-v1/routes/ \
  -H "Content-Type: application/json" \
  -d '{"name": "notification-route-v1", "paths": [ "/api/v1/notification" ], "protocols": [ "http", "https" ], "methods": [ "GET", "PUT", "PATCH", "POST", "DELETE", "OPTIONS", "HEAD", "TRACE", "CONNECT" ]}'

curl -X POST http://localhost:8001/services/notification-service-v2/routes/ \
  -H "Content-Type: application/json" \
  -d '{"name": "notification-route-v2", "paths": [ "/api/v2/notification" ], "protocols": [ "http", "https" ], "methods": [ "GET", "PUT", "PATCH", "POST", "DELETE", "OPTIONS", "HEAD", "TRACE", "CONNECT" ]}'

curl -X POST http://localhost:8001/services/notification-public/routes/ \
  -H "Content-Type: application/json" \
  -d '{"name": "notification-route-public", "paths": [ "/api/notification/public" ], "protocols": [ "http", "https" ], "methods": [ "GET", "PUT", "PATCH", "POST", "DELETE", "OPTIONS", "HEAD", "TRACE", "CONNECT" ]}'

curl -X POST http://localhost:8001/services/notification-openapi/routes/ \
  -H "Content-Type: application/json" \
  -d '{"name": "notification-route-openapi", "paths": [ "/docs/v1/notification", "/docs/notification" ], "protocols": [ "http", "https" ], "methods": [ "GET", "PUT", "PATCH", "POST", "DELETE", "OPTIONS", "HEAD", "TRACE", "CONNECT" ]}'