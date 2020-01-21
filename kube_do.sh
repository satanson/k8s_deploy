#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

source ${basedir}/functions.sh

echo "choose [$(green_print CMD)]:"
cmd=$(selectOption \
  "stop" "start" "restart" "status" \
  "deploy_bin" "deploy_conf" "deploy_bin_and_conf" \
  "upgrade_bin" "upgrade_conf" "upgrade_bin_and_conf")

if isIn ${cmd} "start|stop|restart|status|upgrade_bin|upgrade_conf|upgrade_bin_and_conf";then
  echo "choose [$(green_print SERVICE)]:"
  service=$(selectOption "kube-apiserver" "kube-scheduler" "kube-controller-manager" "kubelet" "kube-proxy")
fi

echo "choose [$(green_print HOST LIST)]:"
hostList=$(selectOption $(find hosts -type f))

echo "exec [$(yellow_print ${cmd} ${service}@${hostList})]:"
confirm

deploy_bin_of_k8s(){
  ./deploy_k8s_bin.sh ${1:?"missing 'hostList'"}
}

deploy_conf_of_k8s(){
  ./deploy_k8s_tls.sh ${1:?"missing 'hostList'"}
  ./deploy_k8s_etc.sh ${1:?"missing 'hostList'"}
  ./deploy_k8s_systemd.sh ${1:?"missing 'hostList'"}
  ./deploy_k8s_scripts.sh ${1:?"missing 'hostList'"}
}

deploy_bin_and_conf_of_k8s(){
  deploy_bin_of_k8s
  deploy_conf_of_k8s
}

if isIn ${cmd} "start|stop|restart|status";then
  ./doall.sh ${hostList} "sudo systemctl ${cmd} ${service};sudo systemctl status ${service}"
elif isIn ${cmd} "deploy_bin|deploy_conf|deploy_bin_and_conf";then
  ${cmd}_of_k8s ${hostList}
elif isIn ${cmd} "upgrade_bin|upgrade_conf|upgrade_bin_and_conf";then
  deploy${cmd##upgrade}_of_k8s ${hostList}
  ./doall.sh ${hostList} "sudo systemctl restart ${service};sudo systemctl status ${service}"
fi
