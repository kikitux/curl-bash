#!/usr/bin/env bash

which nodejs &>/dev/null || {
  export DEBIAN_FRONTEND=noninteractive

  which curl &>/dev/null || {
    apt-get update
    apt-get install -y curl
  }

  curl -sL https://deb.nodesource.com/setup_15.x | bash -
  apt-get install -y nodejs

}
