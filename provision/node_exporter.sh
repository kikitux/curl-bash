#!/usr/bin/env bash

which curl tar &>/dev/null || {
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y curl tar
}

which node_exporter &>/dev/null || {
  curl -sL -o /tmp/node_exporter.tgz https://github.com/prometheus/node_exporter/releases/download/v0.17.0/node_exporter-0.17.0.linux-amd64.tar.gz
  tar zxvf /tmp/node_exporter.tgz -C /usr/local/
  ln -s /usr/local/node_exporter-0.17.0.linux-amd64/node_exporter /usr/local/bin/node_exporter
}

curl -s -o /etc/systemd/system/node_exporter.service https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/node_exporter.service

systemctl enable node_exporter.service
systemctl start node_exporter.service

[ -d /etc/consul.d ] && {
  cat <<EOF | tee /etc/consul.d/node_exporter.hcl
{
  "service": {
    "name": "node_exporter",
    "port": 9100,
    "tags": ["http"]
  },
  "checks": [
    {
      "name": "node_exporter-basic-connectivity",
      "tcp": "localhost:9100",
      "interval": "10s",
      "timeout": "1s"
    }
  ]
}
EOF

  service consul reload
}
