#!/bin/bash

host=$(hostname -s)

KUBELET_LOG_ARGS="--logtostderr=false --alsologtostderr=true --log-dir=/opt/kubernetes/logs --v=0"

KUBE_ARGS="\
  --kubeconfig=/opt/kubernetes/etc/kubeconfig.conf \
  --cluster-cidr 10.65.0.0/16 \
  --proxy-mode=ipvs \
  --ipvs-scheduler=wrr \
  --hostname-override=${host} \
  ${KUBELET_LOG_ARGS} \
  "
