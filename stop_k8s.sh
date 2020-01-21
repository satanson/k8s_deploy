#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

hostList=${1:?"missing 'hostList'"};shift

./doall.sh ${hostList} "\
  sudo systemctl stop kube-proxy \
  sudo systemctl stop kubelet \
  sudo systemctl stop kube-controller-manager \
  sudo systemctl stop kube-scheduler \
  sudo systemctl stop kube-apiserver \
  "
