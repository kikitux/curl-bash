#!/usr/bin/env bash

[ "${PRODUCT}" ] || {
	echo warn: script need variable PRODUCT=name_of_product
	echo info: skipping to run
	exit 0
}

for P in ${PRODUCT}; do
  which ${P} &>/dev/null || {

    # download tools
    which curl wget unzip jq tar &>/dev/null || {
      export DEBIAN_FRONTEND=noninteractive
      apt-get update
      apt-get install --no-install-recommends -y curl wget unzip jq tar
    }

    [ "${P}" == "node_exporter" ] && {
      URL=`curl -sL -o /dev/null -w %{url_effective} https://github.com/prometheus/node_exporter/releases/latest`
      VERSION=${URL##*/}

      curl -sL -o /tmp/node_exporter.tgz https://github.com/prometheus/node_exporter/releases/download/${VERSION}/node_exporter-${VERSION#v}.linux-amd64.tar.gz
      tar zxvf /tmp/node_exporter.tgz -C /usr/local/
      rm /tmp/node_exporter.tgz
      ln -s /usr/local/node_exporter-${VERSION#v}.linux-amd64/node_exporter /usr/local/bin/node_exporter
      continue

    }
    
    [ "${P}" == "grafana-server" ] && {
      export DEBIAN_FRONTEND=noninteractive
      apt-get update
      apt-get install -y gnupg
      apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8C8C34C524098CB6
      echo 'deb https://packages.grafana.com/oss/deb stable main' | tee /etc/apt/sources.list.d/grafana.list
      curl -fsSL https://packages.grafana.com/gpg.key | apt-key add -
      apt-get update
      apt-get install -y grafana apt-transport-https
      systemctl daemon-reload
      systemctl enable grafana-server
      continue
    }

    # we use version we got in a variable, or just download latest stable
    [ "${VERSION}" ] || {
      VERSION=$(curl -sL https://releases.hashicorp.com/${P}/index.json | jq -r '.versions[].version' | sort -V | egrep -v 'ent|beta|rc|alpha' | tail -n1)
    }

    # arch
    if [[ "`uname -m`" =~ "arm" ]]; then
      ARCH=arm
    elif [[ "`uname -m`" == "aarch64" ]]; then
      ARCH=arm64      
    else
      ARCH=amd64
    fi

    # ent

    if [ "${P}" == "consul" ] && [ "${ENT}" ] ; then
      P="consul+ent"
    fi

    if [ "${P}" == "vault" ] && [ "${ENT}" ] ; then
      P="vault+ent"
    fi

    wget -q -O /tmp/${P}.zip https://releases.hashicorp.com/${P}/${VERSION}/${P}_${VERSION}_linux_${ARCH}.zip
    unzip -o -d /usr/local/bin /tmp/${P}.zip
    rm /tmp/${P}.zip

  }
done
