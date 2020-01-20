#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

source ${basedir}/functions.sh

test -f /etc/ceph/ceph.conf

cluster=$(perl -ne 'print $1 if /^\s*cluster\s*=\s*(\w+)\s*$/' /etc/ceph/ceph.conf)
cluster=${cluster:-"ceph"}
fsid="$(perl -lne 'print $1 if/^\s*fsid\s*=\s*(.*?)\s*$/' /etc/ceph/ceph.conf|tail -1)"
mon_initial_members="$(perl -lne 'print $1 if/^\s*mon_initial_members\s*=\s*(.*?)\s*$/' /etc/ceph/ceph.conf|tail -1)"
host=$(hostname)
id=${host}

green_print "mon_initial_members=${mon_initial_members} host=${host}"

if ! isIn ${host} $(replace_before_remove_whitespace ${mon_initial_members} "," "|");then
  red_print "ERROR: ${host} is not in ${mon_initial_members}" 
  exit 1
fi

mon_data=/var/lib/ceph/mon/${cluster}-${id}

test -d ${mon_data}

green_print "start ceph-mon"

chown -R ceph:ceph /var/lib/ceph
chown -R ceph:ceph /var/run/ceph
chown -R ceph:ceph /var/log/ceph
chown -R ceph:ceph /etc/ceph

exec ceph-mon -f --conf /etc/ceph/ceph.conf --id ${host} --mon-data ${mon_data} --setuser ceph --setgroup ceph
