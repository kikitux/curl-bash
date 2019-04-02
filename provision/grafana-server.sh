#!/usr/bin/env bash


which grafana-server &>/dev/null || {
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y gnupg
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8C8C34C524098CB6
  echo 'deb https://packages.grafana.com/oss/deb stable main' | tee /etc/apt/sources.list.d/grafana.list
  curl -fsSL https://packages.grafana.com/gpg.key | apt-key add -
  apt-get update
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
