#!/usr/bin/env bash

curl -sL -o /usr/local/bin/fabio https://github.com/fabiolb/fabio/releases/download/v1.5.11/fabio-1.5.11-go1.11.5-linux_amd64
chmod +x /usr/local/bin/fabio

curl -sL -o /etc/systemd/system/fabio.service https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/fabio.service

systemctl enable fabio.service
systemctl start fabio.service
