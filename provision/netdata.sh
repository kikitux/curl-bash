#!/usr/bin/env bash

which netdata 2>/dev/null || {
  curl -s https://packagecloud.io/install/repositories/netdata/netdata/script.deb.sh | sudo bash
  apt-get update
  apt-get install -y netdata
  sed -i -e 's/localhost/0.0.0.0/g' /etc/netdata/netdata.conf

  systemctl enable netdata.service
  systemctl restart netdata.service
}
