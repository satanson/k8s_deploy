#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

rgw_secret=$(ceph-authtool --gen-print-key)
keyring=/etc/ceph/ceph.client.rgw.keyring
ceph-authtool --create-keyring ${keyring} --name client.rgw --add-key ${rgw_secret}
ceph auth add client.rgw  osd 'allow rwx' mon 'allow rw' -i ${keyring}

