#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

loopdev=${1:?"missing 'loopdev'"};shift
vg=${1:?"missing 'vg'"};shift
lv=${1:?"missing 'lg'"};shift
#capacity=${1:?"missing 'capacity'"};shift
#size=${1:?"missing 'size'"};shift

sudo lvremove -f ${vg}/${lv}
sudo vgremove ${vg}
sudo pvremove /dev/${loopdev}
sudo losetup  -d /dev/${loopdev}
sudo rm /dev/${loopdev:?"undefined"}
sudo rm /data01/${loopdev}
