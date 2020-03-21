#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

host=$(hostname)
id=${host}

cluster=$(perl -ne 'print $1 if /^\s*cluster\s*=\s*(\w+)\s*$/' /etc/ceph/ceph.conf)
test -d /var/lib/ceph
mds_data=/var/lib/ceph/mds/${cluster}-${id}
test -d ${mds_data}
keyring=/var/lib/ceph/mds/${cluster}-${id}/keyring
test -f ${keyring}

chown -R ceph:ceph /var/lib/ceph
chown -R ceph:ceph /var/log/ceph
chown -R ceph:ceph /var/run/ceph
chown -R ceph:ceph /etc/ceph

exec ceph-mds -f -c /etc/ceph/ceph.conf -i ${id} --setuser ceph --setgroup ceph
