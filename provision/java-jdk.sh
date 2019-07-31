#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

dpkg -l default-jdk 2>/dev/null || {
  apt-get update
  apt-get install -y default-jdk
}
