#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

hostList=${1:?"missing 'hostList' file"};shift

source ${basedir}/functions.sh

for rs in $(ipList ${hostList});do
	set +e +o pipefail
	if ! ssh -i ${basedir}/id_rsa_vagrant vagrant@${rs} "$*";then
		echo "${rs}: ERROR";
	fi
	set -e -o pipefail
done
