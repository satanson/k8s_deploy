#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

source ${basedir}/functions.sh
ceph fs fail cephfs
ceph fs rm cephfs --yes-i-really-mean-it
${basedir}/delete_pool.sh cephfs_data cephfs_metadata
