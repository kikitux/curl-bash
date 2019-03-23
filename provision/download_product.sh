#!/usr/bin/env bash

[ "${PRODUCT}" ] || {
	echo warn: script need variable PRODUCT=name_of_product
	echo info: skipping to run
	exit 0
}

for P in ${PRODUCT}; do
  which ${P} &>/dev/null || {

    # download tools
    which curl wget unzip jq &>/dev/null || {
      export DEBIAN_FRONTEND=noninteractive
      apt-get update
      apt-get install --no-install-recommends -y curl wget unzip jq
    }

    VERSION=$(curl -sL https://releases.hashicorp.com/${P}/index.json | jq -r '.versions[].version' | sort -V | egrep -v 'ent|beta|rc|alpha' | tail -n1)

    # arch
    if [[ "`uname -m`" =~ "arm" ]]; then
      ARCH=arm
    else
      ARCH=amd64
    fi

    wget -q -O /tmp/${P}.zip https://releases.hashicorp.com/${P}/${VERSION}/${P}_${VERSION}_linux_${ARCH}.zip
    unzip -o -d /usr/local/bin /tmp/${P}.zip
    rm /tmp/${P}.zip

  }
done
