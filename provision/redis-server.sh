#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

which redis-server &>/dev/null || {
  apt-get update
  apt-get install -y redis-server
}

[ -d /etc/consul.d ] && {
  cat <<EOF | tee /etc/consul.d/redis.hcl
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
  sed -i -e 's/^bind.*/#bind 127.0.0.1/g' /etc/redis/redis.conf
  service redis-server force-reload
  service consul reload
}
