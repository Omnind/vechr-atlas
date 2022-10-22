#!/bin/bash

# Service
curl -X POST http://localhost:8001/services \
  -H "Content-Type: application/json" \
  -d '{"name": "audit-service-v1", "host": "host.docker.internal", "port": 3005, "path": "/api/v1/audit"}'

curl -X POST http://localhost:8001/services \
  -H "Content-Type: application/json" \
  -d '{"name": "audit-service-v2", "host": "host.docker.internal", "port": 3005, "path": "/api/v2/audit"}'

curl -X POST http://localhost:8001/services \
  -H "Content-Type: application/json" \
  -d '{"name": "audit-public", "host": "host.docker.internal", "port": 3005, "path": "/api/audit/public"}'

curl -X POST http://localhost:8001/services \
  -H "Content-Type: application/json" \
  -d '{"name": "audit-openapi", "host": "host.docker.internal", "port": 3005, "path": "/api/audit"}'


# Route
curl -X POST http://localhost:8001/services/audit-service-v1/routes/ \
  -H "Content-Type: application/json" \
  -d '{"name": "audit-route-v1", "paths": [ "/api/v1/audit" ], "protocols": [ "http", "https" ], "methods": [ "GET", "PUT", "PATCH", "POST", "DELETE", "OPTIONS", "HEAD", "TRACE", "CONNECT" ]}'

curl -X POST http://localhost:8001/services/audit-service-v2/routes/ \
  -H "Content-Type: application/json" \
  -d '{"name": "audit-route-v2", "paths": [ "/api/v2/audit" ], "protocols": [ "http", "https" ], "methods": [ "GET", "PUT", "PATCH", "POST", "DELETE", "OPTIONS", "HEAD", "TRACE", "CONNECT" ]}'

curl -X POST http://localhost:8001/services/audit-public/routes/ \
  -H "Content-Type: application/json" \
  -d '{"name": "audit-route-public", "paths": [ "/api/audit/public" ], "protocols": [ "http", "https" ], "methods": [ "GET", "PUT", "PATCH", "POST", "DELETE", "OPTIONS", "HEAD", "TRACE", "CONNECT" ]}'

curl -X POST http://localhost:8001/services/audit-openapi/routes/ \
  -H "Content-Type: application/json" \
  -d '{"name": "audit-route-openapi", "paths": [ "/docs/v1/audit", "/docs/audit" ], "protocols": [ "http", "https" ], "methods": [ "GET", "PUT", "PATCH", "POST", "DELETE", "OPTIONS", "HEAD", "TRACE", "CONNECT" ]}'