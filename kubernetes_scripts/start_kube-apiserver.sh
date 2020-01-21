#!/bin/bash
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
exec ${basedir}/start_kube.sh kube-apiserver
