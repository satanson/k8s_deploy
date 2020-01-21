#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

./doall.sh hosts/k8s.list "\
  sudo route del -net 0.0.0.0 netmask 0.0.0.0 gw 192.168.128.1 dev eth1;\
  sudo route -n"
