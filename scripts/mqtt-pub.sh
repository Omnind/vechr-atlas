#!/bin/sh
mosquitto_pub -h nats-server -p 1883 -t "NATS/MQTT/Test/" -m "Hello World"