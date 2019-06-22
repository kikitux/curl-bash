#!/usr/bin/env bash

# download vault
which vault &>/dev/null || {
export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install --no-install-recommends -y curl wget unzip jq

  #always use highest release
  VAULT=$(curl -sL https://releases.hashicorp.com/vault/index.json | jq -r '.versions[].version' | sort -V | egrep -v 'ent|beta|rc|alpha' | tail -n1)

  # arch
  if [[ "`uname -m`" =~ "arm" ]]; then
    ARCH=arm
  elif [[ "`uname -m`" == "aarch64" ]]; then
    ARCH=arm64
  else
    ARCH=amd64
  fi

  wget -q -O /tmp/vault.zip https://releases.hashicorp.com/vault/${VAULT}/vault_${VAULT}_linux_${ARCH}.zip
  unzip -o -d /usr/local/bin /tmp/vault.zip
}

mkdir -p /etc/vault.d
#download server configuration
curl -sL -o /etc/vault.d/server.hcl https://raw.githubusercontent.com/kikitux/curl-bash/master/vault-dev/vault.d/server.hcl
#download systemd service
curl -sL -o /etc/systemd/system/vault.service https://raw.githubusercontent.com/kikitux/curl-bash/master/vault-dev/vault.service

systemctl enable vault.service
systemctl start vault.service 2>/dev/null

echo "vault-dev installed"
