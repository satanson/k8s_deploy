#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

pool=${1:?"missing 'pool'"};shift
image=${1:?"missing 'image'"};shift


exists=$(rbd device list |perl -lne "print 1 if /\\b${pool}\\b.*\\b(${image})\\b/")
if [ -n "${exists}" ];then
  set +e +o pipefail
  sudo rbd device unmap ${pool}/${image}
  set -e -o pipefail
fi
exists=$(rbd device list |perl -lne "print 1 if /\\b${pool}\\b.*\\b(${image})\\b/")
test -z "${exists}"

if rbd info ${pool}/${image};then
  rbd remove ${pool}/${image}
fi

rbd ls ${pool}
