#!/usr/bin/env bash

# curl -sL https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/fio.sh | TEST_DIR=/var/tmp/fiotest sudo bash

if [ "$1" ]; then
  TEST_DIR=$1
else
  TEST_DIR=${TEST_DIR:-/var/tmp/fiotest}
fi

mkdir -p ${TEST_DIR}
if  [ $? -ne 0 ] ; then
  echo err: no write permissions on ${TRST_DIR}
  exit 1
fi

which fio || {
   apt-get update
   apt-get install -y fio
}

fio --name=read_throughput --directory=$TEST_DIR --numjobs=12 \
	--size=1G --time_based --runtime=20s --ramp_time=2s --ioengine=libaio \
	--direct=1 --verify=0 --bs=1M --iodepth=64 --rw=read \
	--group_reporting=1

rm -r $TEST_DIR
