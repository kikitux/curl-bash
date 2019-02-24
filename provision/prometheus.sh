#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

which prometheus &>/dev/null || {

  apt-get update
  apt-get install --no-install-recommends -y curl wget tar

  # arch
  if [[ "`uname -m`" =~ "arm" ]]; then
    ARCH=armv7
  else
    ARCH=amd64
  fi

  cd /usr/local

  wget -q https://github.com/prometheus/prometheus/releases/download/v2.7.1/prometheus-2.7.1.linux-${ARCH}.tar.gz
  tar zxvf prometheus-2.7.1.linux-${ARCH}.tar.gz

  ln -s /usr/local/prometheus-2.7.1.linux-${ARCH}/prometheus /usr/local/bin/prometheus
  ln -s /usr/local/prometheus-2.7.1.linux-${ARCH}/promtool /usr/local/bin/promtool

}

# create dir and copy prometheus.yml
mkdir -p /etc/prometheus
curl -o /etc/prometheus/prometheus.yml https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/prometheus.yml
curl -o /etc/systemd/system/prometheus.service https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/prometheus.service

systemctl enable prometheus.service
systemctl start prometheus.service

[ -d /etc/consul.d ] && {
  cat <<EOF | tee /etc/consul.d/prometheus.hcl
{
  "service": {
    "name": "prometheus",
    "port": 9090
  },
  "checks": [
    {
      "name": "prometheus-basic-connectivity",
      "tcp": "localhost:9090",
      "interval": "10s",
      "timeout": "1s"
    }
  ]
}
EOF

  service consul reload
}
