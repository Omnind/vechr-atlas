#!/bin/bash

# Service
curl -X POST http://localhost:8001/services \
  -H "Content-Type: application/json" \
  -d '{"name": "auth-service-v1", "host": "host.docker.internal", "port": 3002, "path": "/api/v1/auth"}'

curl -X POST http://localhost:8001/services \
  -H "Content-Type: application/json" \
  -d '{"name": "auth-service-v2", "host": "host.docker.internal", "port": 3002, "path": "/api/v2/auth"}'

curl -X POST http://localhost:8001/services \
  -H "Content-Type: application/json" \
  -d '{"name": "auth-public", "host": "host.docker.internal", "port": 3002, "path": "/api/auth/public"}'

curl -X POST http://localhost:8001/services \
  -H "Content-Type: application/json" \
  -d '{"name": "auth-openapi", "host": "host.docker.internal", "port": 3002, "path": "/api/auth"}'


# Route
curl -X POST http://localhost:8001/services/auth-service-v1/routes/ \
  -H "Content-Type: application/json" \
  -d '{"name": "auth-route-v1", "paths": [ "/api/v1/auth" ], "protocols": [ "http", "https" ], "methods": [ "GET", "PUT", "PATCH", "POST", "DELETE", "OPTIONS", "HEAD", "TRACE", "CONNECT" ]}'

curl -X POST http://localhost:8001/services/auth-service-v2/routes/ \
  -H "Content-Type: application/json" \
  -d '{"name": "auth-route-v2", "paths": [ "/api/v2/auth" ], "protocols": [ "http", "https" ], "methods": [ "GET", "PUT", "PATCH", "POST", "DELETE", "OPTIONS", "HEAD", "TRACE", "CONNECT" ]}'

curl -X POST http://localhost:8001/services/auth-public/routes/ \
  -H "Content-Type: application/json" \
  -d '{"name": "auth-route-public", "paths": [ "/api/auth/public" ], "protocols": [ "http", "https" ], "methods": [ "GET", "PUT", "PATCH", "POST", "DELETE", "OPTIONS", "HEAD", "TRACE", "CONNECT" ]}'

curl -X POST http://localhost:8001/services/auth-openapi/routes/ \
  -H "Content-Type: application/json" \
  -d '{"name": "auth-route-openapi", "paths": [ "/docs/v1/auth", "/docs/auth" ], "protocols": [ "http", "https" ], "methods": [ "GET", "PUT", "PATCH", "POST", "DELETE", "OPTIONS", "HEAD", "TRACE", "CONNECT" ]}'