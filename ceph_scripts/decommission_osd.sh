#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

id=${1:?"missing 'osd id'"};shift
ceph osd out osd.${id}
#ceph osd destroy osd.${id}
ceph osd crush remove osd.${id}
ceph osd rm osd.${id}
ceph auth del osd.${id}
