#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}
${basedir}/add_libraries.sh
radosgw -f --cluster ceph --name client.rgw --keyring /etc/ceph/ceph.client.rgw.keyring
