#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

host=$(hostname)
id=${host}

cluster=$(perl -ne 'print $1 if /^\s*cluster\s*=\s*(\w+)\s*$/' /etc/ceph/ceph.conf)
test -d /var/lib/ceph
mds_data=/var/lib/ceph/mds/${cluster}-${id}
keyring=/var/lib/ceph/mds/${cluster}-${id}/keyring
mkdir -p ${mds_data}
rm -fr ${mds_data:?"undefined"}/*

ceph-authtool --create-keyring ${keyring} --gen-key -n mds.${id}
ceph auth add mds.${id} osd "allow rwx" mds "allow" mon "allow profile mds" -i ${keyring}
