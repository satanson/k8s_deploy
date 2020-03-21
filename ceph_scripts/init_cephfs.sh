#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

device_string=${1:?"missing 'device_string'"};shift

source ${basedir}/functions.sh
pools=$(ceph osd pool ls|perl -ne 'chomp;push @a,$_}{print join qq#|#,@a')
if ! isIn  cephfs_data "${pools}";then
  ceph osd pool create cephfs_data 2  2
fi

if ! isIn cephfs_metadata "${pools}";then
  ceph osd pool create cephfs_metadata 2  2
fi

if ceph fs ls|grep "No filesystems enabled" >/dev/null 2>&1; then
  ceph fs new cephfs cephfs_metadata cephfs_data
fi

sleep 5

ceph fs ls;
ceph mds stat

secret_key=$(ceph fs authorize cephfs client.cephfs / rw |perl -lne 'print $1 if /key\s*=\s*(\S+)\s*$/')
mnt=/home/ceph/cephfs_mnt
mkdir -p ${mnt}
#device_string=$(perl -ne 'push @a, $1 if/^\s*(\b\d+(?:\.\d+){3}\b)\s*\bceph_mon[0-2]\b/}{print join qq/,/,map{qq/$_:6789/} @a' /etc/hosts)
sudo mount -t ceph ${device_string}:/ ${mnt} -o name=cephfs,secret=${secret_key}
sudo chown -R ceph:ceph  ${mnt}
echo "Hello World!!" > ${mnt}/test.txt
sync ${mnt}
sudo umount ${mnt}
sudo mount -t ceph ${device_string}:/ ${mnt} -o name=cephfs,secret=${secret_key}
sudo chown -R ceph:ceph  ${mnt}
cat ${mnt}/test.txt
s=$(cat ${mnt}/test.txt)
if [ "${s}" = "Hello World!!" ];then
  green_print "PASS"
else
  red_print "FAIL"
fi
