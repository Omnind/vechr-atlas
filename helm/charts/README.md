# Vechr App

Vechr app is application IIoT for manufacturing, and running on kubernetes Cluster, Vechr can run on premises, cloud as long as having kubernetes cluster.

## TL;DR;
```bash
helm repo add vechr https://vechr.github.io/vechr-atlas/helm/charts/
helm repo update
helm install vechr vechr/vechr
```

## Configuration

### Ingress
```yaml
ingresses:
  -
    name: audit-kong-service
    enabled: true
    services:
      -
        name: vechr-microservice-audit-service
        path: /api/v2/audit
        port: 3004
      -
        name: vechr-microservice-audit-service
        path: /api/v1/audit
        port: 3004
      -
        name: vechr-microservice-audit-service
        path: /api/audit
        port: 3004
  -
    name: auth-kong-service
    enabled: true
    services:
      -
        name: vechr-microservice-auth-service
        path: /api/v2/auth
        port: 3005
      -
        name: vechr-microservice-auth-service
        path: /api/v1/auth
        port: 3005
      -
        name: vechr-microservice-auth-service
        path: /api/auth
        port: 3005
  -
    name: notification-kong-service
    enabled: true
    services:
      -
        name: vechr-microservice-notification-service
        path: /api/v2/notification
        port: 3002
      -
        name: vechr-microservice-notification-service
        path: /api/v1/notification
        port: 3002
      -
        name: vechr-microservice-notification-service
        path: /api/notification
        port: 3002
  -
    name: things-kong-service
    enabled: true
    services:
      -
        name: vechr-microservice-things-service
        path: /api/v2/things
        port: 3001
      -
        name: vechr-microservice-things-service
        path: /api/v1/things
        port: 3001
      -
        name: vechr-microservice-things-service
        path: /api/things
        port: 3001
  -
    name: web-app-kong
    enabled: true
    services:
      -
        name: vechr-frontend-web-app
        path: /
        port: 80
```

### Common Application
```yaml
common:
  postgres:
    - 
      name: "audit-db"
      externalPort: 5436
      enabled: true

      env:
        - name: POSTGRES_DB
          value: "audit_db"
        - name: POSTGRES_USER
          value: Vechr
        - name: POSTGRES_PASSWORD
          value: "123"
    - 
      name: "auth-db"
      externalPort: 5435
      enabled: true

      env:
        - name: POSTGRES_DB
          value: "auth_db"
        - name: POSTGRES_USER
          value: Vechr
        - name: POSTGRES_PASSWORD
          value: "123"
    - 
      name: "notification-db"
      externalPort: 5434
      enabled: true

      env:
        - name: POSTGRES_DB
          value: "notification_db"
        - name: POSTGRES_USER
          value: Vechr
        - name: POSTGRES_PASSWORD
          value: "123"
    - 
      name: "things-db"
      externalPort: 5433
      enabled: true

      env:
        - name: POSTGRES_DB
          value: "things_db"
        - name: POSTGRES_USER
          value: Vechr
        - name: POSTGRES_PASSWORD
          value: "123"

  frontend:
    name: web-app
    image: zulfikar4568/web-app
    tag: latest
    enabled: true

    # imagePullPolicy: Always is recommended when using latest tags. Otherwise, please use IfNotPresent
    imagePullPolicy: Always

    port: 80
    externalPort: 80

    # Resource
    resources:
      requests:
        memory: "100Mi"
        cpu: "100m"
      limits:
        memory: "1024Mi"
        cpu: "1"

  influx:
    name: influxdb
    replicas: 2
    enabled: true
    deployment:
      image: influxdb
      tag: 2.1.0-alpine
    influx:
      mode: setup
      organization: Vechr
      bucket: Vechr
      token: vechr-token
    auth:
      username: admin
      password: isnaen1998

```

## Microservices
You can enable Horizontal Auto Pod Scalling in this Microservices
```yaml
microservices:
  -
    name: audit-service
    image: zulfikar4568/audit-service
    tag: latest
    enabled: true

    # imagePullPolicy: Always is recommended when using latest tags. Otherwise, please use IfNotPresent
    imagePullPolicy: Always

    # these will be passed as environment variables
    env:
      - name: APP_PORT
        value: "3000"
      - name: NATS_URL
        value: "nats://vechr-nats.default.svc.cluster.local:4222"
      - name: JWT_SECRET
        value: "secretvechr"
      - name: ECRYPTED_SECRET
        value: "usersecret"
      - name: JWT_EXPIRES_IN
        value: "3d"
      - name: DB_URL
        value: "postgresql://Vechr:123@vechr-postgres-audit-db.default.svc.cluster.local:5436/audit_db?schema=public&connect_timeout=300"

    # this will expose port 80 on the host on port 8080
    port: 3000
    externalPort: 3004

    # Resource
    resources:
      requests:
        memory: "300Mi"
        cpu: "300m"
      limits:
        memory: "1024Mi"
        cpu: "1"

    hpa:
      enabled: false
      minReplicas: 1
      maxReplicas: 2
      averageUtilization: 70
  -
    name: auth-service
    image: zulfikar4568/auth-service
    tag: latest
    enabled: true

    # imagePullPolicy: Always is recommended when using latest tags. Otherwise, please use IfNotPresent
    imagePullPolicy: Always

    # these will be passed as environment variables
    env:
      - name: APP_PORT
        value: "3000"
      - name: NATS_URL
        value: "nats://vechr-nats.default.svc.cluster.local:4222"
      - name: JWT_SECRET
        value: "secretvechr"
      - name: ECRYPTED_SECRET
        value: "usersecret"
      - name: JWT_EXPIRES_IN
        value: "3d"
      - name: DB_URL
        value: "postgresql://Vechr:123@vechr-postgres-auth-db.default.svc.cluster.local:5435/auth_db?schema=public&connect_timeout=300"
      - name: JWT_REFRESH_EXPIRES_IN
        value: "30d"
      - name: INITIAL_SITE
        value: '{"code":"ST1","name":"Site Default","location":"Server Default"}'
      - name: INITIAL_SUPERUSER
        value: '{"fullName":"root","username": "root","emailAddress":"root@vechr.id","phoneNumber":"+62","password":"password123"}'

    # this will expose port 3000 on the host on port 3005
    port: 3000
    externalPort: 3005

    # Resource
    resources:
      requests:
        memory: "300Mi"
        cpu: "300m"
      limits:
        memory: "1024Mi"
        cpu: "1"

    hpa:
      enabled: false
      minReplicas: 1
      maxReplicas: 2
      averageUtilization: 70
  -
    name: db-logger-service
    image: zulfikar4568/db-logger-service
    tag: latest
    enabled: true

    # imagePullPolicy: Always is recommended when using latest tags. Otherwise, please use IfNotPresent
    imagePullPolicy: Always

    # these will be passed as environment variables
    env:
      - name: APP_PORT
        value: "3000"
      - name: NATS_URL
        value: "nats://vechr-nats.default.svc.cluster.local:4222"
      - name: JWT_SECRET
        value: "secretvechr"
      - name: ECRYPTED_SECRET
        value: "usersecret"
      - name: JWT_EXPIRES_IN
        value: "3d"
      - name: INFLUX_URL
        value: "http://influxdb-service.default.svc.cluster.local:8086/"
      - name: INFLUX_TOKEN
        value: "vechr-token"
      - name: INFLUX_ORG
        value: "Vechr"
      - name: INFLUX_BUCKET
        value: "Vechr"

    # this will expose port 3000 on the host on port 3003
    port: 3000
    externalPort: 3003

    # Resource
    resources:
      requests:
        memory: "300Mi"
        cpu: "300m"
      limits:
        memory: "1024Mi"
        cpu: "1"

    hpa:
      enabled: true
      minReplicas: 1
      maxReplicas: 2
      averageUtilization: 70
  -
    name: notification-service
    image: zulfikar4568/notification-service
    tag: latest
    enabled: true

    # imagePullPolicy: Always is recommended when using latest tags. Otherwise, please use IfNotPresent
    imagePullPolicy: Always

    # these will be passed as environment variables
    env:
      - name: APP_PORT
        value: "3000"
      - name: NATS_URL
        value: "nats://vechr-nats.default.svc.cluster.local:4222"
      - name: JWT_SECRET
        value: "secretvechr"
      - name: ECRYPTED_SECRET
        value: "usersecret"
      - name: JWT_EXPIRES_IN
        value: "3d"
      - name: EMAIL_ID
        value: isnaen71@gmail.com
      - name: EMAIL_PASS
        value: ofhbzrgtvmzbgrlh
      - name: EMAIL_HOST
        value: gmail-service.default.svc.cluster.local
      - name: EMAIL_PORT
        value: "587"
      - name: DB_URL
        value: "postgresql://Vechr:123@vechr-postgres-notification-db.default.svc.cluster.local:5434/notification_db?schema=public&connect_timeout=300"

    # this will expose port 3000 on the host on port 3002
    port: 3000
    externalPort: 3002

    # Resource
    resources:
      requests:
        memory: "300Mi"
        cpu: "300m"
      limits:
        memory: "1024Mi"
        cpu: "1"

    hpa:
      enabled: false
      minReplicas: 1
      maxReplicas: 2
      averageUtilization: 70
  -
    name: things-service
    image: zulfikar4568/things-service
    tag: latest
    enabled: true

    # imagePullPolicy: Always is recommended when using latest tags. Otherwise, please use IfNotPresent
    imagePullPolicy: Always

    # these will be passed as environment variables
    env:
      - name: APP_PORT
        value: "3000"
      - name: NATS_URL
        value: "nats://vechr-nats.default.svc.cluster.local:4222"
      - name: JWT_SECRET
        value: "secretvechr"
      - name: ECRYPTED_SECRET
        value: "usersecret"
      - name: JWT_EXPIRES_IN
        value: "3d"
      - name: DB_URL
        value: "postgresql://Vechr:123@vechr-postgres-things-db.default.svc.cluster.local:5433/things_db?schema=public&connect_timeout=300"

    # this will expose port 3000 on the host on port 3002
    port: 3000
    externalPort: 3001
      
    # Resource
    resources:
      requests:
        memory: "300Mi"
        cpu: "300m"
      limits:
        memory: "1024Mi"
        cpu: "1"

    hpa:
      enabled: false
      minReplicas: 1
      maxReplicas: 2
      averageUtilization: 70

```

## NATS
You can refer to the documentation for Configuration [NATS](https://artifacthub.io/packages/helm/nats/nats)
```yaml
nats:
  enabled: true
  cluster:
    enabled: true
    replicas: 3
    noAdvertise: true

  nats:
    image: nats:alpine
    jetstream:
      enabled: true

      memStorage:
        enabled: true
        size: 2Gi

      fileStorage:
        enabled: true
        size: 1Gi
        storageDirectory: /data/

  mqtt:
    enabled: true
    port: 1883

  websocket:
    enabled: true
    port: 9090

  natsbox:
    enabled: true
```

## API Gateway (KONG)
You can refer to [KONG](https://artifacthub.io/packages/helm/kong/kong) for Configuration
```yaml
kong:
  enabled: true
  admin:
    # Enable creating a Kubernetes service for the admin API
    # Disabling this is recommended for most ingress controller configurations
    # Enterprise users that wish to use Kong Manager with the controller should enable this
    enabled: true
    type: NodePort
    # To specify annotations or labels for the admin service, add them to the respective
    # "annotations" or "labels" dictionaries below.
    annotations: {}
    #  service.beta.kubernetes.io/aws-load-balancer-proxy-protocol: "*"
    labels: {}

    http:
      # Enable plaintext HTTP listen for the admin API
      # Disabling this and using a TLS listen only is recommended for most configuration
      enabled: true
      servicePort: 8001
      containerPort: 8001
      # Set a nodePort which is available if service type is NodePort
      # nodePort: 32080
      # Additional listen parameters, e.g. "reuseport", "backlog=16384"
      parameters: []

    tls:
      # Enable HTTPS listen for the admin API
      enabled: true
      servicePort: 8444
      containerPort: 8444
      # Set a target port for the TLS port in the admin API service, useful when using TLS
      # termination on an ELB.
      # overrideServiceTargetPort: 8000
      # Set a nodePort which is available if service type is NodePort
      # nodePort: 32443
      # Additional listen parameters, e.g. "reuseport", "backlog=16384"
      parameters:
      - http2

    # Kong admin ingress settings. Useful if you want to expose the Admin
    # API of Kong outside the k8s cluster.
    ingress:
      # Enable/disable exposure using ingress.
      enabled: false
      ingressClassName:
      # TLS secret name.
      # tls: kong-admin.example.com-tls
      # Ingress hostname
      hostname:
      # Map of ingress annotations.
      annotations: {}
      # Ingress path.
      path: /
      # Each path in an Ingress is required to have a corresponding path type. (ImplementationSpecific/Exact/Prefix)
      pathType: ImplementationSpecific

```