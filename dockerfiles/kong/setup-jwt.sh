#!/bin/bash

# Create JWT global config
curl -X POST http://localhost:8001/plugins \
  -d "name=jwt" \
  -d "config.header_names=authorization" \
  -d "config.key_claim_name=key" \
  -d "config.cookie_names=kreJWT" \
  -d "config.maximum_expiration=657000"

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

curl -X POST http://localhost:8001/consumers \
  -H "Content-Type: application/json" \
  -d '{"username": "notification-consumer"}'

# Create credential jwt things consumer
curl -X POST http://localhost:8001/consumers/things-consumer/jwt \
  -d "key=Vechr-things" \
  -d "algorithm=HS256" \
  -d "secret=SANGAT_RAHASIA"

curl -X POST http://localhost:8001/consumers/auth-consumer/jwt \
  -d "key=Vechr-auth" \
  -d "algorithm=HS256" \
  -d "secret=SANGAT_RAHASIA"

curl -X POST http://localhost:8001/consumers/db-logger-consumer/jwt \
  -d "key=Vechr-db-logger" \
  -d "algorithm=HS256" \
  -d "secret=SANGAT_RAHASIA"

curl -X POST http://localhost:8001/consumers/notification-consumer/jwt \
  -d "key=Vechr-notification" \
  -d "algorithm=HS256" \
  -d "secret=SANGAT_RAHASIA"

# Testing JWT
# curl -X GET localhost:8000/api/things/v1 -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtleSI6ImtyZU1FUyJ9.eyJleHAiOjY1N30.RGVVYLb2a1r4HT_hQczjWc87xUjXUB_cZrsFJk1nYjI'