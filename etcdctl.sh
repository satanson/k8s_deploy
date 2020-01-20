#!/bin/bash
set -e -o pipefail
sudo etcdctl --cert=/opt/etcd/tls/client.pem --cacert=/opt/etcd/tls/ca.pem --key /opt/etcd/tls/client-key.pem --endpoints=https://192.168.139.10:2379,https://192.168.139.11:2379,https://192.168.139.12:2379 $*
