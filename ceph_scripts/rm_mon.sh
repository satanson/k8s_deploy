#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

source ${basedir}/functions.sh

cluster=$(perl -ne 'print $1 if /^\s*cluster\s*=\s*(\w+)\s*$/' /etc/ceph/ceph.conf)
cluster=${cluster:-"ceph"}
host=$(hostname)
id=${host}
ip=$(hostname -i)

pidFile=/var/run/ceph/${cluster}-${id}.pid
pid=$(cat ${pidFile})
kill -0 ${pid} && kill -9 ${pid}
ceph mon rm ${id}
