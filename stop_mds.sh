#!/bin/bash

set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}
id=$(hostname -s)
sudo systemctl stop ceph-mds@${id}
sudo systemctl status ceph-mds@${id}

