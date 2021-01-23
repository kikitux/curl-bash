#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
  
which python3 &>/dev/null || {
  apt-get update
  apt-get install -y python3
}

which pip3 &>/dev/null || {
  apt-get install -y python3-pip
}

which pipenv &>/dev/null || {
  pip3 install pipenv
}
