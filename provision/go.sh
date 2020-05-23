#!/usr/bin/env bash

which go || {
  # make sure apt database is up-to date
  apt-get update

  # install golang-${GOVER}
  apt-get install -y snapd
  snap install go --classic

  # set base
  # if we are in sudo use the calling user
  # we use eval as ~ won't be expanded
  if [ "${SUDO_USER}" ]; then
    BASE="`eval echo ~${SUDO_USER}/.bash_profile`"
  else
    BASE="`eval echo ~/.bash_profile`"
  fi

  grep 'GOPATH|GOROOT' ${BASE} &>/dev/null || {
    sudo mkdir -p ~/go
    [ -f ${BASE} ] && cp ${BASE} ${BASE}.ori
    grep -v 'GOPATH|GOROOT' ${BASE}.ori | sudo tee -a ${BASE}
    echo 'export GOROOT=/snap/go/current' | sudo tee -a ${BASE}
    echo 'export PATH=$PATH:/snap/bin:$GOROOT/bin' | sudo tee -a ${BASE}
    echo 'export GOPATH=~/go' | sudo tee -a ${BASE}
  }

  if [ "${SUDO_USER}" ]; then
    chown ${SUDO_USER} ${BASE}
    [ -f ${BASE}.ori ] && chown ${SUDO_USER} ${BASE}.ori
  fi

}
