#!/usr/bin/env bash

# download consul
which consul &>/dev/null || {
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install --no-install-recommends -y curl wget unzip jq

  CONSUL=$(curl -sL https://releases.hashicorp.com/consul/index.json | jq -r '.versions[].version' | sort -V | egrep -v 'ent|beta|rc|alpha' | tail -n1)

  # arch
  if [[ "`uname -m`" =~ "arm" ]]; then
    ARCH=arm
  elif [[ "`uname -m`" == "aarch64" ]]; then
    ARCH=arm64
  else
    ARCH=amd64
  fi

  wget -q -O /tmp/consul.zip https://releases.hashicorp.com/consul/${CONSUL}/consul_${CONSUL}_linux_${ARCH}.zip
  unzip -o -d /usr/local/bin /tmp/consul.zip
}

# create dir and copy server.hcl for consul
mkdir -p /etc/consul.d
curl -o /etc/systemd/system/consul.service https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-cloud-join/consul.service

# if we have WAN_JOIN then we are on the 2nd dc
if [ "${WAN_JOIN}" ] ; then
  curl -o /etc/consul.d/server.hcl https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-cloud-join/consul.d/server-dc2.hcl
  sed -i "s/192.168.56.20/${WAN_JOIN}/g" /etc/consul.d/*.hcl
# else we are on the 1st dc
else
  curl -o /etc/consul.d/server.hcl https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-cloud-join/consul.d/server-dc1.hcl
fi

# if we have DC var, we need to rename the DC
# if DC and WAN_JOIN, we are on dc2
if [ "${DC}" ] && [ "${WAN_JOIN}" ] ; then
  sed -i "s/dc2/${DC}/g" /etc/consul.d/*.hcl
# elif DC only, we are on dc1
elif [ "${DC}" ] ; then
  sed -i "s/dc1/${DC}/g" /etc/consul.d/*.hcl
fi

# adjust interface if not named enp0s8
if [ "${IFACE}" ] ; then
  sed -i "s/enp0s8/${IFACE}/g" /etc/consul.d/*.hcl
fi

# adjust BOOTSTRAPEXPECT
if [ "${BOOTSTRAPEXPECT}" ] ; then
  sed -i "s/BOOTSTRAPEXPECT/${BOOTSTRAPEXPECT}/g" /etc/consul.d/*.hcl
else
  sed -i "s/BOOTSTRAPEXPECT/1/g" /etc/consul.d/*.hcl
fi

# adjust RETRYJOIN
if [ "${RETRYJOIN}" ] ; then
  sed -i "s/RETRYJOIN/${RETRYJOIN}/g" /etc/consul.d/*.hcl
else
  sed -i "s/RETRYJOIN//g" /etc/consul.d/*.hcl
fi

systemctl enable consul.service
systemctl start consul.service
