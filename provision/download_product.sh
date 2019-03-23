#!/usr/bin/env bash

[ "${PRODUCT}" ] || {
	echo warn: script need variable PRODUCT=name_of_product
	echo info: skipping to run
	exit 0
}

which ${PRODUCT} &>/dev/null || {

  # download tools
  which curl wget unzip jq &>/dev/null || {
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install --no-install-recommends -y curl wget unzip jq
  }

  VERSION=$(curl -sL https://releases.hashicorp.com/${PRODUCT}/index.json | jq -r '.versions[].version' | sort -V | egrep -v 'ent|beta|rc|alpha' | tail -n1)

  # arch
  if [[ "`uname -m`" =~ "arm" ]]; then
    ARCH=arm
  else
    ARCH=amd64
  fi

  wget -q -O /tmp/${PRODUCT}.zip https://releases.hashicorp.com/${PRODUCT}/${VERSION}/${PRODUCT}_${VERSION}_linux_${ARCH}.zip
  unzip -o -d /usr/local/bin /tmp/${PRODUCT}.zip
  rm /tmp/${PRODUCT}.zip

}
