#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

name=${1:?"missing 'name'"};shift

DOCKER_OPT=""
if [ ${name} != "none"  ];then
  DOCKER_OPT="--name ${name}"
fi

sudo docker run  ${DOCKER_OPT} --rm --net host \
  --privileged \
  -v /etc/ceph/:/etc/ceph \
  -v /var/lib/ceph:/var/lib/ceph \
  -v /var/run/ceph:/var/run/ceph \
  -v /var/log/ceph:/var/log/ceph \
  -v /dev:/dev \
  -v /opt/ceph_scripts:/opt/ceph_scripts \
  dockerhub.vagrant.info/ceph/ceph_node_centos:7.4.1708 $*
