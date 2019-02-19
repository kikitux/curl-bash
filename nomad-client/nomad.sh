#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

which nomad &>/dev/null || {
  apt-get update
  apt-get install --no-install-recommends -y curl wget unzip jq

  #always use highest release
  NOMAD=$(curl -sL https://releases.hashicorp.com/nomad/index.json | jq -r '.versions[].version' | sort -V | egrep -v 'ent|beta|rc|alpha' | tail -n1)

  # arch
  if [[ "`uname -m`" =~ "arm" ]]; then
    ARCH=arm
  else
    ARCH=amd64
  fi

  wget -O /tmp/nomad.zip https://releases.hashicorp.com/nomad/${NOMAD}/nomad_${NOMAD}_linux_${ARCH}.zip
  unzip -d /usr/local/bin /tmp/nomad.zip
}

which docker java &>/dev/null || {
apt-get update
apt-get install --no-install-recommends -y docker.io
apt-get install --no-install-recommends -y default-jre
docker run hello-world &>/dev/null && echo docker hello-world works
}

# create dir and copy server.hcl for nomad
mkdir -p /etc/nomad.d
curl -o /etc/nomad.d/client.hcl https://raw.githubusercontent.com/kikitux/curl-bash/master/nomad-client/nomad.d/client-dc1.hcl
curl -o /etc/systemd/system/nomad.service https://raw.githubusercontent.com/kikitux/curl-bash/master/nomad-1server/nomad.service

if [ "${DC}" ] && [ "${DC}" != "dc1" ]; then
  sed -i "s/dc1/${DC}/g" /etc/nomad.d/*.hcl
fi

# adjust interfce if not named enp0s8
if [ "${IFACE}" ]; then
  sed -i "s/enp0s8/${IFACE}/g" /etc/nomad.d/*.hcl
fi

if [ "${LAN_JOIN}" ] ; then
  sed -i "s/192.168.56.20/${LAN_JOIN}/g" /etc/nomad.d/*.hcl
fi

systemctl enable nomad.service
systemctl start nomad.service
