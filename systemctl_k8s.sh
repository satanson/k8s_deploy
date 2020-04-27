#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

hostList=${1:?"missing 'hostList'"};shift
cmd=${1:?"missing 'cmd(start|stop|restart|status)'"};shift

./doall.sh ${hostList} "sudo systemctl ${cmd} kube-apiserver kube-scheduler kube-controller-manager kubelet kube-proxy"
