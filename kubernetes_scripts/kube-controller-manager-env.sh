#!/bin/bash

host=$(hostname -s)

KUBE_LOG_ARGS="--logtostderr=false --alsologtostderr=true --log-dir=/opt/kubernetes/logs --v=0"

ip=$(hostname -i)

KUBE_ARGS=" \
  --master=https://${ip}:6443 \
  --root-ca-file=/opt/kubernetes/tls/ca.pem \
  --service-account-private-key-file=/opt/kubernetes/tls/apiserver-key.pem \
  --pod-eviction-timeout=300s \
  --kubeconfig=/opt/kubernetes/etc/kubeconfig.conf \
  ${KUBE_LOG_ARGS} \
  "
