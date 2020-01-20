#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

loopdev=${1:?"missing 'loopdev'"};shift
vg=${1:?"missing 'vg'"};shift
lv=${1:?"missing 'lg'"};shift
#capacity=${1:?"missing 'capacity'"};shift
#size=${1:?"missing 'size'"};shift

minor=${loopdev##loop}

[ ! -f /data01/${loopdev} ] && dd if=/dev/zero of=/data01/${loopdev} bs=1M count=20K
[ ! -b /dev/${loopdev} ] && sudo mknod /dev/${loopdev} b 7 ${minor}
sudo losetup  /dev/${loopdev}  /data01/${loopdev}

sudo pvcreate /dev/${loopdev}
sudo vgcreate ${vg} /dev/${loopdev}
sudo lvcreate -n ${lv} -L 15g ${vg}
