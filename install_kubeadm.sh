#!/bin/bash
set -e -o pipefail

export http_proxy=http://127.0.0.1:7777
export https_proxy=$http_proxy
export ftp_proxy=$http_proxy
export rsync_proxy=$http_proxy
printf -v no_proxy '%s,' 172.{16..32};
export NO_PROXY="localhost,127.0.0.1,10.,$no_proxy 192.168.,192.168.99.100"

apt install kubeadm
