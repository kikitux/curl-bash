#!/usr/bin/env bash
set -e

docker version 2>/dev/null || {

  apt-get update
  apt-get install -y apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  apt-key fingerprint 0EBFCD88
  add-apt-repository \
    "deb https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
  apt-get update
  mkdir -p /etc/docker

  apt-get install -y docker-ce
  docker run --rm hello-world

  #configure docker port
  [ -f /etc/systemd/system/docker.service.d/docker.conf ] || {
    mkdir -p /etc/systemd/system/docker.service.d
    cat > /etc/systemd/system/docker.service.d/docker.conf <<EOF
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix://var/run/docker.sock
EOF
    systemctl daemon-reload
    systemctl restart docker
  }

}


