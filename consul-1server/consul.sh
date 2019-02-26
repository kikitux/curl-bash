#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

which consul &>/dev/null || {
  apt-get update
  apt-get install --no-install-recommends -y curl wget unzip jq

  CONSUL=$(curl -sL https://releases.hashicorp.com/consul/index.json | jq -r '.versions[].version' | sort -V | egrep -v 'ent|beta|rc|alpha' | tail -n1)

  # arch
  if [[ "`uname -m`" =~ "arm" ]]; then
    ARCH=arm
  else
    ARCH=amd64
  fi

  wget -q -O /tmp/consul.zip https://releases.hashicorp.com/consul/${CONSUL}/consul_${CONSUL}_linux_${ARCH}.zip
  unzip -o -d /usr/local/bin /tmp/consul.zip
}

# create dir and copy server.hcl for consul
mkdir -p /etc/consul.d
curl -o /etc/systemd/system/consul.service https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-1server/consul.service

if [ "${DC}" ] && [ "${DC}" != "dc1" ]; then
  curl -o /etc/consul.d/server.hcl https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-1server/consul.d/server-dc2.hcl
  sed -i "s/dc2/${DC}/g" /etc/consul.d/*.hcl
else
  curl -o /etc/consul.d/server.hcl https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-1server/consul.d/server-dc1.hcl
fi

if [ "${WAN_JOIN}" ] ; then
  sed -i "s/192.168.56.20/${WAN_JOIN}/g" /etc/consul.d/*.hcl
fi

# adjust interface if not named enp0s8
if [ "${IFACE}" ] ; then
  sed -i "s/enp0s8/${IFACE}/g" /etc/consul.d/*.hcl
fi

systemctl enable consul.service
systemctl start consul.service
