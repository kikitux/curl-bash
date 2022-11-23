#!/usr/bin/env bash

# vars IFACE

# curl -sL https://github.com/kikitux/curl-bash/raw/master/nomad-1server/nomad.sh | bash 

# download nomad
which nomad &>/dev/null || {

  which curl wget unzip jq &>/dev/null || {
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install --no-install-recommends -y curl wget unzip jq
  }

  #always use highest release
  NOMAD=$(curl -sL https://releases.hashicorp.com/nomad/index.json | jq -r '.versions[].version' | sort -V | egrep -v 'ent|beta|rc|alpha' | tail -n1)

  # arch
  if [[ "`uname -m`" =~ "arm" ]]; then
    ARCH=arm
  elif [[ "`uname -m`" == "aarch64" ]]; then
    ARCH=arm64
  else
    ARCH=amd64
  fi

  wget -q -O /tmp/nomad.zip https://releases.hashicorp.com/nomad/${NOMAD}/nomad_${NOMAD}_linux_${ARCH}.zip
  unzip -d /usr/local/bin /tmp/nomad.zip
}

# create dir and copy server.hcl for nomad
mkdir -p /etc/nomad.d
curl -o /etc/systemd/system/nomad.service https://raw.githubusercontent.com/kikitux/curl-bash/master/nomad-1server/nomad.service

# if we have WAN_JOIN then we are on the 2nd dc
if [ "${WAN_JOIN}" ] ; then
  curl -o /etc/nomad.d/server.hcl https://raw.githubusercontent.com/kikitux/curl-bash/master/nomad-1server/nomad.d/server-dc2.hcl
  sed -i "s/192.168.56.20/${WAN_JOIN}/g" /etc/nomad.d/*.hcl
# else we are on the 1st dc
else
  curl -o /etc/nomad.d/server.hcl https://raw.githubusercontent.com/kikitux/curl-bash/master/nomad-1server/nomad.d/server-dc1.hcl
fi

# region default to global
if [ "${REGION}" ]; then
  sed -i -e "s/region = \"global\"/region = \"${REGION}\"/g" /etc/nomad.d/*.hcl
fi

# if we have DC var, we need to rename the DC
# if DC and WAN_JOIN, we are on dc2
if [ "${DC}" ] && [ "${WAN_JOIN}" ] ; then
  sed -i "s/dc2/${DC}/g" /etc/nomad.d/*.hcl
# elif DC only, we are on dc1
elif [ "${DC}" ] ; then
  sed -i "s/dc1/${DC}/g" /etc/nomad.d/*.hcl
fi

# adjust interface if not named enp0s8
if [ "${IFACE}" ] ; then
  sed -i "s/enp0s8/${IFACE}/g" /etc/consul.d/*.hcl
fi

# adjust interfce if not named enp0s8
if [ "${IFACE}" ]; then
  sed -i "s/enp0s8/${IFACE}/g" /etc/nomad.d/*.hcl
fi

systemctl enable nomad.service
systemctl start nomad.service
