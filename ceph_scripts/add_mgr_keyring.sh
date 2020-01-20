#!/bin/bash

set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}
node=mgr
num=$(perl -ne "print if /^\\s*\\d+(\\.\\d+){3}\\s+ceph_${node}\\d+\\s*$/" /etc/hosts |wc -l);

for id in $(eval "echo {0..$((num-1))}");do
  keyring=/etc/ceph/ceph.${node}.${id}.keyring
  secret=$(ceph-authtool --gen-print-key)
  echo ceph-authtool --create-keyring ${keyring} --name ${node}.${id} --add-key ${secret}
  echo ceph auth add ${node}.${id} ${node} 'allow *' mon 'allow rwx' -i ${keyring}
done
