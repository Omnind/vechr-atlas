## Setup Influx DB
```bash
helm template influxdb influx --values ./influx/values.yaml
helm install influxdb influx --values ./influx/values.yaml
```