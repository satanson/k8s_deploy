#!/bin/bash
set -x -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

source ${basedir}/functions.sh
pools=$(ceph osd pool ls 2>/dev/null|perl -ne 'chomp;push @a,$_}{print join qq#|#,@a')
echo "before remove $*"
ceph osd pool ls
ceph config set mon mon_allow_pool_delete true
for pool in $*;do
  if isIn ${pool} ${pools};then
    ceph osd pool rm ${pool} ${pool}  --yes-i-really-really-mean-it
  fi
done
ceph config set mon mon_allow_pool_delete false
echo "after remove $*"
ceph osd pool ls
