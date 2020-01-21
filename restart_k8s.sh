#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

hostList=${1:?"missing 'hostList'"};shift

./doall.sh ${hostList} "\
  sudo systemctl restart kube-apiserver \
  sudo systemctl restart kube-scheduler \
  sudo systemctl restart kube-controller-manager \
  sudo systemctl restart kubelet \
  sudo systemctl restart kube-proxy \
  "
