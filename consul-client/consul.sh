#!/usr/bin/env bash

apt-get update
apt-get install --no-install-recommends -y wget unzip dnsmasq

CONSUL=$(curl -sL https://releases.hashicorp.com/consul/index.json | jq -r '.versions[].version' | sort -V | egrep -v 'ent|beta|rc|alpha' | tail -n1)

# arch
if [[ "`uname -m`" =~ "arm" ]]; then
  ARCH=arm
else
  ARCH=amd64
fi

# dnsmasq to use consul dns
curl -o /etc/dnsmasq.d/10-consul https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-1server/dnsmasq.d/consul

wget -O /tmp/consul.zip https://releases.hashicorp.com/consul/${CONSUL}/consul_${CONSUL}_linux_${ARCH}.zip
unzip -o -d /usr/local/bin /tmp/consul.zip

# create dir and copy server.hcl for consul
mkdir -p /etc/consul.d
curl -o /etc/consul.d/client.hcl https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-client/consul.d/client-dc1.hcl
curl -o /etc/systemd/system/consul.service https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-1server/consul.service

# adjust interfce if not named enp0s8
if [ "${IFACE}" != "enp0s8" ] && [ -f /etc/consul.d/client.hcl ]; then
  sed -i "s/enp0s8/${IFACE}/g" /etc/consul.d/client.hcl
fi

systemctl enable consul.service
systemctl start consul.service
