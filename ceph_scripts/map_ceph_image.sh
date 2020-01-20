#!/bin/bash
set -x -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

pool=${1:?"missing 'pool'"};shift
image=${1:?"missing 'image'"};shift

if ! ceph osd pool stats ${pool};then
  ceph osd pool create ${pool} 2 2
fi
ceph osd pool stats ${pool}

if ! rbd pool stats ${pool};then
  rbd pool init ${pool}
fi
rbd pool stats ${pool}

if ! rbd info ${pool}/${image};then
  rbd create --size 1024 ${pool}/${image}
fi
rbd info ${pool}/${image}

exists=$(rbd device list |perl -lne "print 1 if /\\b${pool}\\b.*\\b(${image})\\b/")
if [ -z "${exists}" ];then
  set +e +o pipefail
  sudo rbd device map ${pool}/${image}
  set -x -e -o pipefail
fi
exists=$(rbd device list |perl -lne "print 1 if /\\b${pool}\\b.*\\b(${image})\\b/")
test -n "${exists}"
