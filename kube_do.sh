#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

source ${basedir}/functions.sh

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


op_cluster(){
  echo "choose [$(green_print CMD)]:"
  local cmd=$(selectOption "bootstrap" "start" "stop" "restart" "teardown")

  echo "choose [$(green_print HOST LIST)]:"
  local hostList=$(selectOption $(find hosts -type f))

  echo "exec [$(yellow_print systemctl_k8s.sh ${hostList} ${cmd} )]:"
  confirm
  ./systemctl_k8s.sh ${hostList} ${cmd}
}

op_service(){
  echo "choose [$(green_print SERVICE)]:"
  local service=$(selectOption "kube-apiserver" "kube-scheduler" "kube-controller-manager" "kubelet" "kube-proxy")

  echo "choose [$(green_print CMD)]:"
  local cmd=$(selectOption \
    "stop" "start" "restart" "status" \
    "deploy_bin" "deploy_conf" "deploy_bin_and_conf" \
    "upgrade_bin" "upgrade_conf" "upgrade_bin_and_conf")

  echo "choose [$(green_print HOST LIST)]:"
  local hostList=$(selectOption $(find hosts -type f))

  echo "exec [$(yellow_print ${cmd} ${service}@${hostList})]:"
  confirm

  if isIn ${cmd} "start|stop|restart|status";then
    ./doall.sh ${hostList} "sudo systemctl ${cmd} ${service};sudo systemctl status ${service}"
  elif isIn ${cmd} "deploy_bin|deploy_conf|deploy_bin_and_conf";then
    ${cmd}_of_k8s ${hostList}
    ./doall.sh ${hostList} "sudo systemctl restart ${service};sudo systemctl status ${service}"
  elif isIn ${cmd} "upgrade_bin|upgrade_conf|upgrade_bin_and_conf";then
    deploy${cmd##upgrade}_of_k8s ${hostList}
    ./doall.sh ${hostList} "sudo systemctl restart ${service};sudo systemctl status ${service}"
  fi
}

op(){
  echo "choose [$(green_print TARGET)]:"
  local target=$(selectOption "cluster" "service")
  if isIn ${target} "cluster";then
    op_cluster
  else
    op_service
  fi
}

op
