#!/bin/sh
mosquitto_sub -h nats-server -p 1883 -t "NATS/MQTT/Test/#"