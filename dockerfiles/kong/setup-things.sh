#!/bin/bash

# Service
curl -X POST http://localhost:8001/services \
  -H "Content-Type: application/json" \
  -d '{"name": "things-service-v1", "host": "host.docker.internal", "port": 3003, "path": "/api/v1/things"}'

curl -X POST http://localhost:8001/services \
  -H "Content-Type: application/json" \
  -d '{"name": "things-service-v2", "host": "host.docker.internal", "port": 3003, "path": "/api/v2/things"}'

curl -X POST http://localhost:8001/services \
  -H "Content-Type: application/json" \
  -d '{"name": "things-public", "host": "host.docker.internal", "port": 3003, "path": "/api/things/public"}'

curl -X POST http://localhost:8001/services \
  -H "Content-Type: application/json" \
  -d '{"name": "things-openapi", "host": "host.docker.internal", "port": 3003, "path": "/api/things"}'


# Route
curl -X POST http://localhost:8001/services/things-service-v1/routes/ \
  -H "Content-Type: application/json" \
  -d '{"name": "things-route-v1", "paths": [ "/api/v1/things" ], "protocols": [ "http", "https" ], "methods": [ "GET", "PUT", "PATCH", "POST", "DELETE", "OPTIONS", "HEAD", "TRACE", "CONNECT" ]}'

curl -X POST http://localhost:8001/services/things-service-v2/routes/ \
  -H "Content-Type: application/json" \
  -d '{"name": "things-route-v2", "paths": [ "/api/v2/things" ], "protocols": [ "http", "https" ], "methods": [ "GET", "PUT", "PATCH", "POST", "DELETE", "OPTIONS", "HEAD", "TRACE", "CONNECT" ]}'

curl -X POST http://localhost:8001/services/things-public/routes/ \
  -H "Content-Type: application/json" \
  -d '{"name": "things-route-public", "paths": [ "/api/things/public" ], "protocols": [ "http", "https" ], "methods": [ "GET", "PUT", "PATCH", "POST", "DELETE", "OPTIONS", "HEAD", "TRACE", "CONNECT" ]}'

curl -X POST http://localhost:8001/services/things-openapi/routes/ \
  -H "Content-Type: application/json" \
  -d '{"name": "things-route-openapi", "paths": [ "/docs/v1/things", "/docs/things" ], "protocols": [ "http", "https" ], "methods": [ "GET", "PUT", "PATCH", "POST", "DELETE", "OPTIONS", "HEAD", "TRACE", "CONNECT" ]}'