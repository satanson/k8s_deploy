#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

hostList=${1:?"missing 'hostList'"};shift

./doall.sh ${hostList} "\
  sudo systemctl start kube-apiserver \
  sudo systemctl start kube-scheduler \
  sudo systemctl start kube-controller-manager \
  sudo systemctl start kubelet \
  sudo systemctl start kube-proxy \
  "
