#!/bin/bash

KUBE_LOG_ARGS="--logtostderr=false --alsologtostderr=true --log-dir=/opt/kubernetes/logs --v=0"

KUBE_ARGS="\
  --master=https://127.0.0.1:6443 \
  --bind-address=0.0.0.0 \
  --secure-port=10259 \
  --kubeconfig=/opt/kubernetes/etc/kubeconfig.conf \
  ${KUBE_LOG_ARGS} \
  "
