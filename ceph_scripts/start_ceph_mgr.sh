#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

source ${basedir}/functions.sh

test -f /etc/ceph/ceph.conf
cluster=$(perl -ne 'print $1 if /^\s*cluster\s*=\s*(\w+)\s*$/' /etc/ceph/ceph.conf)
cluster=${cluster:-"ceph"}
host=$(hostname)
id=${host}
ip=$(perl -aF/\\s+/ -ne "print \$F[0] if /\b$host\b/" /etc/hosts)
test -d /var/lib/ceph
mgr_data=/var/lib/ceph/mgr/${cluster}-${id}
test -d ${mgr_data}
keyring=/var/lib/ceph/mgr/${cluster}-${id}/keyring
test -f ${keyring}

chown -R ceph:ceph /var/lib/ceph
chown -R ceph:ceph /var/log/ceph
chown -R ceph:ceph /var/run/ceph
chown -R ceph:ceph /etc/ceph

green_print "Start ceph-mgr@${id}"
exec ceph-mgr -f -i ${id} --setuser ceph --setgroup ceph 
