#!/usr/bin/env bash
set -e

apt-get update
apt-get install --no-install-recommends -y curl wget unzip

#always use highest release
VAULT=$(curl -sL https://releases.hashicorp.com/vault/index.json | jq -r '.versions[].version' | sort -V | grep -v 'beta|rc|alpha' | tail -n1)

# arch
if [[ "`uname -m`" =~ "arm" ]]; then
  ARCH=arm
else
  ARCH=amd64
fi

wget -O /tmp/vault.zip https://releases.hashicorp.com/vault/${VAULT}/vault_${VAULT}_linux_${ARCH}.zip
unzip -o -d /usr/local/bin /tmp/vault.zip

mkdir -p /etc/vault.d
#download server configuration
curl -sL -o /etc/vault.d/server.hcl https://raw.githubusercontent.com/kikitux/curl-bash/master/vault-dev/vault.d/server.hcl
#download systemd service
curl -sL -o /etc/systemd/system/vault.service https://raw.githubusercontent.com/kikitux/curl-bash/master/vault-dev/vault.service

systemctl enable vault.service
systemctl start vault.service 2>/dev/null
