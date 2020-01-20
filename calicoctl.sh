#!/bin/bash
set -e -o pipefail
export DATASTORE_TYPE=etcdv3
export ETCD_ENDPOINTS=https://192.168.139.10:2379,https://192.168.139.11:2379,https://192.168.139.12:2379
export ETCD_KEY_FILE=/opt/etcd/tls/client-key.pem
export ETCD_CERT_FILE=/opt/etcd/tls/client.pem
export ETCD_CA_CERT_FILE=/opt/etcd/tls/ca.pem
export CALICO_IPV4POOL_CIDR=10.65.0.0/16
sudo -E calicoctl $*

