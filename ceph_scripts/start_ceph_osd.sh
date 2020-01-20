#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

id=${1:?"missing 'osd id'"};shift

source ${basedir}/functions.sh

green_print "Phase 2: Check environment"
osd_data=/var/lib/ceph/osd-${id}
test -d ${osd_data}
green_print "Phase 3: Start ceph-osd"

chown -R ceph:ceph /var/lib/ceph
chown -R ceph:ceph /var/run/ceph
chown -R ceph:ceph /var/log/ceph
chown -R ceph:ceph /etc/ceph

exec ceph-osd -f --conf /etc/ceph/ceph.conf -i ${id}
