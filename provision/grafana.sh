#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

which grafana-server &>/dev/null || {
  echo 'deb https://packages.grafana.com/oss/deb stable main' | tee /etc/apt/sources.list.d/grafana.list
  curl -fsSL https://packages.grafana.com/gpg.key | apt-key add -
  apt-get update -y
  apt-get install -y grafana apt-transport-https
  systemctl daemon-reload
  systemctl enable grafana-server
  systemctl start grafana-server

}

[ -d /etc/consul.d ] && {
  cat <<EOF | tee /etc/consul.d/grafana.hcl
{
  "service": {
    "name": "grafana",
    "port": 3000
  },
  "checks": [
    {
      "name": "grafana-basic-connectivity",
      "tcp": "localhost:3000",
      "interval": "10s",
      "timeout": "1s"
    }

  ]
}
EOF

  service consul reload
}
