#!/bin/bash
set -e

cmd="$@"

# Rabbit MQ dependency
until [ "$(curl -u guest:guest http://rabbitmq:15672/api/queues | grep -o telegraf | wc -l)" -ge 1 ];
do
  >&2 echo "RabbitMQ broker is unavailable - sleeping"
  sleep 5
done

# InfluxDB dependency
until [ "$(curl -s -o /dev/null -w "%{http_code}" http://influxdb:8086/ping)" -eq 204 ];
do
  >&2 echo "InfluxDB is unavailable - sleeping"
  sleep 5
done

>&2 echo "RabbitMQ broker and InfluxDB are up - executing command"
exec $cmd
