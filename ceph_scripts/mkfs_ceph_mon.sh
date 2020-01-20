#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

source ${basedir}/functions.sh

test -f /etc/ceph/ceph.conf
test -f /etc/ceph/monmap
test -f /etc/ceph/ceph.mon.keyring

green_print "Phase 1: Check configuration"

fsid="$(perl -lne 'print $1 if/^\s*fsid\s*=\s*(.*?)\s*$/' /etc/ceph/ceph.conf|tail -1)"
cluster=$(perl -ne 'print $1 if /^\s*cluster\s*=\s*(\w+)\s*$/' /etc/ceph/ceph.conf)
cluster=${cluster:-"ceph"}
mon_initial_members="$(perl -lne 'print $1 if/^\s*mon_initial_members\s*=\s*(.*?)\s*$/' /etc/ceph/ceph.conf|tail -1)"
host=$(hostname)
id=${host}

if ! isIn ${host} $(replace_before_remove_whitespace ${mon_initial_members} "," "|");then
  red_print "ERROR: ${host} is not in ${mon_initial_members}" 
  exit 1
fi

keyring=/etc/ceph/ceph.mon.keyring 
test -f ${keyring}

cat<<DONE
fsid=${fsid}
cluster=${cluster}
mon_initial_members=${mon_initial_members}
host=${host}
id=${id}
keyring=${keyring}:
$(cat ${keyring})
DONE
echo "Done!"
hrule

green_print "Phase 2: Ensure empty mon_data ${mon_data}  exists!"
test -d /var/lib/ceph
mon_data=/var/lib/ceph/mon/${cluster}-${id}
[ -d "${mon_data}" ] && rm -fr ${mon_data:?"undefined"}
mkdir -p ${mon_data}
echo "Done!"
hrule

green_print "Phase 3: Mkfs datadir of ceph-mon: $(whoami)@${host}:${mon_data}"
ceph-mon --mkfs -i ${host} --monmap /etc/ceph/monmap --keyring ${keyring} --mon-data ${mon_data}
cp /etc/ceph/ceph.mon.keyring ${mon_data}/keyring
green_print "Done!"
hrule
green_print "All done!!!"
