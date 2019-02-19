#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get install -y redis-server


[ -d /etc/consul.d ] && {
  cat <<EOF | sudo tee /etc/consul.d/redis.hcl
{
  "service": {
    "name": "redis",
    "port": 6379
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

  #bind to all ports
  sudo sed -i -e 's/bind 127.0.0.1/#bind 127.0.0.1/g' /etc/redis/redis.conf
  sudo service redis reload
  sudo service consul reload
}
