#!/usr/bin/env bash

# check if we got free additional disk
#for disk in /dev/sd?; do
for disk in /dev/disk/by-id/ata-VBOX_HARDDISK_VB????????-???????? ; do
  blkid ${disk} &>/dev/null || disks="${disks} ${disk}"
done

if [ "${disks}" ]; then
  echo we got free disks ${disks}

  which zpool &>/dev/null || {
    echo installing zfs
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y zfsutils-linux 
  }

  zpool create tank ${disks}

fi

# install and configure lxd
which lxd &>/dev/null || {
  echo installing lxd
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -t bionic-backports -y lxd

  usermod -a -G lxd vagrant

  if zpool list tank &>/dev/null ; then
    echo zfs
    lxd init --auto --storage-backend zfs --storage-create-device tank/lxd
  elif btrfs su li /var/lib &>/dev/null ; then
    echo btrfs
    lxd init --auto --storage-backend btrfs --storage-pool default --storage-create-device /var/lib/lxd/storage-pools/default
  else
    lxd init --auto
  fi

  [ -d /var/snap/lxd/common ] || {
    mkdir -p /var/snap/lxd/common/
    ln -s /var/lib/lxd /var/snap/lxd/common/lxd 
  }

  while [ -f /var/lib/lxd/unix.socket ]; do
    echo sleeping for /var/lib/lxd/unix.socket
    ls -al /var/lib/lxd
    sleep 2
  done

  # vagrant will reuse ssh, so no permissions yet
  chown vagrant:lxd /var/lib/lxd/unix.socket
  ls -al /var/snap/lxd/common/lxd/unix.socket

  lxc network set lxdbr0 ipv6.address none
}

# install and configure ctop
which ctop &>/dev/null || {
  echo installing ctop
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -t ctop
}
