#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

bash -x ${basedir}/ceph_scripts/init_cephfs.sh 193.168.139.10:6789,192.168.139.11:6789,192.168.139.12:6789
