#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get install -y redis-server

[ -d /etc/consul.d ] && {
  cat <<EOF | sudo tee /etc/consul.d/redis.json
{
  "service": {
    "name": "redis",
    "port": 6379,
    "address": "127.0.0.1"
  },
  "checks": [
          {
            "name": "redis-basic-connectivity",
            "args": ["/usr/bin/redis-cli", "-h", "127.0.0.1", "-p", "6379", "ping"],
            "interval": "10s"
          }
        ]
}
EOF

  sudo service consul reload
}
