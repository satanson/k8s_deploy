#!/bin/bash

export http_proxy=http://127.0.0.1:7777
export https_proxy=$http_proxy
export ftp_proxy=$http_proxy
export rsync_proxy=$http_proxy

sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo -E apt-get update
sudo -E apt-get install -y kubelet kubeadm kubectl
sudo -E apt-mark hold kubelet kubeadm kubectl
