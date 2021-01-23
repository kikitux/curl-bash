#!/usr/bin/env bash

# pre-req
which apt-add-repository &>/dev/null || {
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y software-properties-common
}

# hashicorp repo
grep hashicorp /etc/apt/sources.list &>/dev/null || {
  export DEBIAN_FRONTEND=noninteractive
  curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
  apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  apt-get update
}

# packer
which packer &>/dev/null || {
  export DEBIAN_FRONTEND=noninteractive
  apt-get install -y packer
  packer version
}
