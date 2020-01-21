#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

service=${1:?"missing 'service'"};shift

source ${basedir}/functions.sh
checkArgument service ${service} "kube-apiserver|kube-scheduler|kube-controller-manager|kubelet|kube-proxy"
bindir=${basedir}/../bin
test -d ${bindir}
bindir=$(readlink -f ${bindir})
logdir=${basedir}/../logs
if [ ! -d ${logdir} ];then
  mkdir -p ${logdir}
fi
logdir=$(readlink -f ${logdir})
test -d ${logdir}

servEnvFile=${basedir}/${service}-env.sh
stdout=${logdir}/${service}.stdout
stderr=${logdir}/${service}.stderr
KUBE_CMD=${bindir}/${service}

unset -- KUBE_ARGS

if [ -f ${servEnvFile} ];then
  source ${servEnvFile}
else
  echo "ERROR: ${servEnvFile} not exist" >&2
  exit 1
fi

if [ -z "${KUBE_ARGS}" ];then
  echo "ERROR: empty KUBE_ARGS" >&2
  exit 1
fi

if [ ! -f "${KUBE_CMD}" ];then
  echo "ERROR: ${KUBE_CMD} not exist" >&2
  exit 1
fi

exec ${KUBE_CMD} ${KUBE_ARGS} >${stdout} 2>${stderr}
