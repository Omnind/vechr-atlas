# kreMES (kre Manufacturing Execution System)
This is Under [kreMES](LICENSE).

# Setup Application
Before pulling you'll need to all **access** for submodule repository.

## Pull repository
```
git clone --recursive git@github.com:zulfikar4568/kreMES.git
```

Edit `.env` file, configure `APP_LISTS`, this line will decided what are the list of container that you'll run.
```
APP_LISTS=things-microservices,auth-microservices,db-logger-microservices,influxdb,nats-server,mosquitto,nats-box
```
## Allowing Script
Script must be have an access before executing
```
chmod 777 scripts/
```

# Running Application

## Running All Container
```bash
./up.sh
```

## Stoping All Container
```bash
./down.sh
```

## Logs container
```bash
#example
./logs.sh influxdb
```

## SSH to container
```bash
#example
./ssh.sh nats-box
```

# Testing NATS with MQTT (Start Publish Subscribe)
Open 4 terminal, and run each command below

## Subscribe to MQTT topic on Terminal 1
This command will listen on topic `NATS/MQTT/Test/#` mqtt
```bash
# ssh to container
./ssh.sh "mosquitto"
# Subscribe message
/scripts/mqtt-sub.sh
# or using this instead mqtt-sub.sh
mosquitto_sub -h nats-server -p 1883 -t "NATS/MQTT/Test/#"
```

## Subcribe to NATS Subject on Terminal 2
This command will listen on subject `NATS.MQTT.Test/>` nats
```bash
# ssh to container
./ssh.sh "nats-box"
# Subscribe message
nats -s nats://nats-server sub "NATS.MQTT.Test.>"
```

## Publish to NATS subject on Terminal 3
You can execute this command several time
```bash
# ssh to container
./ssh.sh "nats-box"
# Publish message
nats -s nats://nats-server pub "NATS.MQTT.Test.>" "This is message from nats"
```

## Publish to MQTT topic on Terminal 4
You can execute this script several time
```bash
# ssh to container
./ssh.sh "mosquitto"
# Publish message
/scripts/mqtt-pub.sh
#or using this instead mqtt-pub.sh
mosquitto_pub -h nats-server -p 1883 -t "NATS/MQTT/Test/" -m "This is message from mqtt"
```


## Publish MQTT Data
Please use this topic format to store in database
`kreMES/DashboardID/<Your Dashboard ID>/DeviceID/<Your Device ID>/topic/<Your Topic Name>`
```bash
mosquitto_pub -h nats-server -p 1883 -t "kreMES/DashboardID/87jk234/DeviceID/9jk2b2189/topic/temp" -m "80.23"
```

## Query Data using Rest API
```bash
curl -X GET http://localhost:3000/api/query \
   -H 'Content-Type: application/json' \
   -d '{"dashboardId": "87jk234", "deviceId": "9jk2b2189", "topic": "temp"}'
```