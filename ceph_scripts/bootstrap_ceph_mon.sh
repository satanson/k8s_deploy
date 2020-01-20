#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

source functions.sh

test -f /etc/ceph/ceph.conf

fsid=$(uuidgen)
green_print "Phase 1: Generate fsid=${fsid}"

perl -i -lpe "s/^\\s*fsid\\s*=\\s*(\\S+)\\s*$/fsid=${fsid}/g" /etc/ceph/ceph.conf
echo "Show /etc/ceph/ceph.conf"
cat /etc/ceph/ceph.conf

hrule

green_print "Phase 2: Create /etc/ceph/ceph.mon.keyring"

ceph-authtool --create-keyring /etc/ceph/ceph.mon.keyring --gen-key -n mon. --cap mon 'allow *'
ceph-authtool --create-keyring /etc/ceph/ceph.client.admin.keyring --gen-key -n client.admin --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow *' --cap mgr 'allow *'
ceph-authtool --create-keyring /etc/ceph/ceph.bootstrap-osd.keyring --gen-key -n client.bootstrap-osd --cap mon 'profile bootstrap-osd' --cap mgr 'allow r'
ceph-authtool --create-keyring /etc/ceph/ceph.bootstrap-mds.keyring --gen-key -n client.bootstrap-mds --cap mon 'profile bootstrap-mds' --cap mgr 'allow r'
ceph-authtool --create-keyring /etc/ceph/ceph.bootstrap-mgr.keyring --gen-key -n client.bootstrap-mgr --cap mon 'profile bootstrap-mgr'
ceph-authtool --create-keyring /etc/ceph/ceph.bootstrap-rgw.keyring --gen-key -n client.bootstrap-rgw --cap mon 'profile bootstrap-rgw'

ceph-authtool /etc/ceph/ceph.mon.keyring --import-keyring /etc/ceph/ceph.client.admin.keyring
ceph-authtool /etc/ceph/ceph.mon.keyring --import-keyring /etc/ceph/ceph.bootstrap-osd.keyring
ceph-authtool /etc/ceph/ceph.mon.keyring --import-keyring /etc/ceph/ceph.bootstrap-mds.keyring
ceph-authtool /etc/ceph/ceph.mon.keyring --import-keyring /etc/ceph/ceph.bootstrap-mgr.keyring
ceph-authtool /etc/ceph/ceph.mon.keyring --import-keyring /etc/ceph/ceph.bootstrap-rgw.keyring
cat /etc/ceph/ceph.mon.keyring

hrule

green_print "Phase 3: Create /etc/ceph/monmap"

majorVersion=$(monmaptool --version |perl -lne 'print $1 if /^ceph\s*version\s*(\d+)\.(\d+)\.(\d+)/')
test -n ${majorVersion}
test ${majorVersion} -ge 13

monInitialMembers="$(perl -lne 'print $1 if/^\s*mon_initial_members\s*=\s*(.*?)\s*$/' /etc/ceph/ceph.conf|tail -1)"
monHost="$(perl -lne 'print $1 if/^\s*mon_host\s*=\s*(.*?)\s*$/' /etc/ceph/ceph.conf|tail -1)"

if [ ${majorVersion} -eq 13 ]; then
  monmaptool --create  --fsid ${fsid} --clobber /etc/ceph/monmap
  while test -n "${monInitialMembers}" -a -n "${monHost}";do
    firstMember=$(list_head ${monInitialMembers?:"undefined"} ",")
    monInitialMembers=$(list_tail ${monInitialMembers?:"undefined"} ",")
    firstHost=$(list_head ${monHost:?"undefined"} ",")
    monHost=$(list_tail ${monHost:?"undefined"} ",")
    test -n "${firstMember}" -a -n "${firstHost}"
    monmaptool --add ${firstMember} ${firstHost} /etc/ceph/monmap
  done
elif [ ${majorVersion} -ge 14 ]; then
  firstMember=$(list_head ${monInitialMembers?:"undefined"} ",")
  monInitialMembers=$(list_tail ${monInitialMembers?:"undefined"}, ",")
  firstHost=$(list_head ${monHost:?"undefined"} ",")
  monHost=$(list_tail ${monHost:?"undefined"} ",")
  test -n "${firstMember}" -a -n "${firstHost}" -a "x${firstMember}x" = "x$(hostname)x" -a "x${firstHost}x" = "x$(hostname -i)x"
  monmaptool --create --add ${firstMember} ${firstHost} --fsid ${fsid}  --set-min-mon-release ${majorVersion} --clobber /etc/ceph/monmap

  while test -n "${monInitialMembers}" -a -n "${monHost}";do
    firstMember=$(list_head ${monInitialMembers?:"undefined"} ",")
    monInitialMembers=$(list_tail ${monInitialMembers?:"undefined"} ",")
    firstHost=$(list_head ${monHost:?"undefined"} ",")
    monHost=$(list_tail ${monHost:?"undefined"} ",")
    test -n "${firstMember}" -a -n "${firstHost}"
    monmaptool --add ${firstMember} ${firstHost} --fsid ${fsid}  --set-min-mon-release ${majorVersion} /etc/ceph/monmap
  done
else
  red_print "invalid version: ${majorVersion}"
  exit 1
fi

monmaptool --print /etc/ceph/monmap

hrule

green_print "All done!!!"
