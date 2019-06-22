#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

which consul-template &>/dev/null || {

  which curl wget unzip jq &>/dev/null || {
    apt-get update
    apt-get install --no-install-recommends -y curl wget unzip jq
  }

  CONSUL_TEMPLATE=$(curl -sL https://releases.hashicorp.com/consul-template/index.json | jq -r '.versions[].version' | sort -V | egrep -v 'ent|beta|rc|alpha' | tail -n1)

  # arch
  if [[ "`uname -m`" =~ "arm" ]]; then
    ARCH=arm
  elif [[ "`uname -m`" == "aarch64" ]]; then
    ARCH=arm
  else
    ARCH=amd64
  fi

  wget -q -O /tmp/consul-template.zip https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE}/consul-template_${CONSUL_TEMPLATE}_linux_${ARCH}.zip
  unzip -o -d /usr/local/bin /tmp/consul-template.zip

}
