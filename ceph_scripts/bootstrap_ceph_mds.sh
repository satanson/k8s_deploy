#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

host=$(hostname)
id=${host}

cluster=$(perl -ne 'print $1 if /^\s*cluster\s*=\s*(\w+)\s*$/' /etc/ceph/ceph.conf)
mds_data=/home/ceph/mon/${cluster}-${id}
keyring=/etc/ceph/${cluster}.mds.${id}.keyring
mkdir -p ${mds_data}
rm -fr ${mds_data:?"undefined"}/*

ceph-authtool --create-keyring ${keyring} --gen-key -n mds.${id}
ceph auth add mds.${id} osd "allow rwx" mds "allow" mon "allow profile mds" -i ${keyring}
