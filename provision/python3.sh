#!/usr/bin/env bash

which pip3 &>/dev/null || {
  export DEBIAN_FRONTEND=noninteractive

  which python3 &>/dev/null || {
    apt-get update
    apt-get install -y python3
  }

  apt-get install -y python3-pip

}
