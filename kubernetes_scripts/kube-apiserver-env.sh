#!/bin/bash

host=$(hostname -s)

KUBE_LOG_ARGS="--logtostderr=false --alsologtostderr=true --log-dir=/opt/kubernetes/logs --v=0"

KUBE_ETCD_SERVERS="\
  --etcd-servers=https://192.168.139.10:2379,https://192.168.139.11:2379,https://192.168.139.12:2379 \
  --etcd-prefix=/registry \
  --etcd-cafile=/opt/kubernetes/tls/ca.pem \
  --etcd-certfile=/opt/kubernetes/tls/etcd_client.pem \
  --etcd-keyfile=/opt/kubernetes/tls/etcd_client-key.pem \
"

ip=$(hostname -i)

KUBE_APISERVER_ENDPOINT="\
  --advertise-address=${ip} \
  --bind-address=0.0.0.0 \
  --secure-port=6443 \
  --client-ca-file=/opt/kubernetes_tls/ca.pem \
  --tls-cert-file=/opt/kubernetes_tls/apiserver.pem \
  --tls-private-key-file=/opt/kubernetes_tls/apiserver-key.pem \
  --insecure-bind-address=127.0.0.1 \
  --insecure-port=8080 \
"

KUBE_ARGS="\
  --max-requests-inflight=2000 \
  --allow-privileged=true \
  --service-cluster-ip-range=10.65.0.0/16 \
  --enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,ResourceQuota \
  ${KUBE_LOG_ARGS} \
  ${KUBE_ETCD_SERVERS} \
  ${KUBE_APISERVER_ENDPOINT} \
  "
