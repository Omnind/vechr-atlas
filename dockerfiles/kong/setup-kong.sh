#!/bin/bash

# Create JWT global config
curl -X POST http://localhost:8001/plugins \
  -d "name=jwt" \
  -d "config.header_names=authorization" \
  -d "config.key_claim_name=key" \
  -d "config.cookie_names=kreJWT" \
  -d "config.maximum_expiration=657000"

# Create Services
curl -X POST http://localhost:8001/services \
  -H "Content-Type: application/json" \
  -d '{"name": "things-microservices", "host": "host.docker.internal", "port": 3003}'

curl -X POST http://localhost:8001/services \
  -H "Content-Type: application/json" \
  -d '{"name": "auth-microservices", "host": "host.docker.internal", "port": 3002}'

curl -X POST http://localhost:8001/services \
  -H "Content-Type: application/json" \
  -d '{"name": "db-logger-microservices", "host": "host.docker.internal", "port": 3001}'

# Create Routes
curl -X POST http://localhost:8001/services/things-microservices/routes/ \
  -H "Content-Type: application/json" \
  -d '{"name": "things-route", "paths": [ "/api/things/v1", "/api/things/v2" ], "protocols": [ "http", "https" ], "methods": [ "GET", "PUT", "PATCH", "POST", "DELETE" ]}'

curl -X POST http://localhost:8001/services/auth-microservices/routes/ \
  -H "Content-Type: application/json" \
  -d '{"name": "auth-route", "paths": [ "/api/auth/v1", "/api/auth/v2" ], "protocols": [ "http", "https" ], "methods": [ "GET", "PUT", "PATCH", "POST", "DELETE" ]}'

curl -X POST http://localhost:8001/services/db-logger-microservices/routes/ \
  -H "Content-Type: application/json" \
  -d '{"name": "db-logger-route", "paths": [ "/api/logger/v1", "/api/logger/v2" ], "protocols": [ "http", "https" ], "methods": [ "GET", "PUT", "PATCH", "POST", "DELETE" ]}'

# Create things consumers
curl -X POST http://localhost:8001/consumers \
  -H "Content-Type: application/json" \
  -d '{"username": "things-consumer"}'

curl -X POST http://localhost:8001/consumers \
  -H "Content-Type: application/json" \
  -d '{"username": "auth-consumer"}'

curl -X POST http://localhost:8001/consumers \
  -H "Content-Type: application/json" \
  -d '{"username": "db-logger-consumer"}'

# Create credential jwt things consumer
curl -X POST http://localhost:8001/consumers/things-consumer/jwt \
  -d "key=kreMES-things" \
  -d "algorithm=HS256" \
  -d "secret=SANGAT_RAHASIA"

curl -X POST http://localhost:8001/consumers/auth-consumer/jwt \
  -d "key=kreMES-auth" \
  -d "algorithm=HS256" \
  -d "secret=SANGAT_RAHASIA"

curl -X POST http://localhost:8001/consumers/db-logger-consumer/jwt \
  -d "key=kreMES-db-logger" \
  -d "algorithm=HS256" \
  -d "secret=SANGAT_RAHASIA"

# Testing JWT
# curl -X GET localhost:8000/api/things/v1 -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtleSI6ImtyZU1FUyJ9.eyJleHAiOjY1N30.RGVVYLb2a1r4HT_hQczjWc87xUjXUB_cZrsFJk1nYjI'