#!/bin/bash

# kubernetes kubelet (minion) config

# The address for the info server to serve on (set to 0.0.0.0 or "" for all interfaces)
KUBELET_ADDRESS="--address=0.0.0.0"

# The port for the info server to serve on
KUBELET_PORT="--port=10250"

# You may leave this blank to use the actual hostname
KUBELET_HOSTNAME="--hostname-override=$(hostname -s)"

# pod infrastructure container
KUBELET_POD_INFRA_CONTAINER="--pod-infra-container-image=dockerhub.vagrant.info/library/pause:3.1"

KUBELET_LOG_ARGS="--log-dir=/opt/kubernetes/logs --log-file=kubelog.log --v=0"

KUBELET_TLS_ARGS="--tls-cert-file=/opt/kubernetes/tls/kubelet.pem --tls-private-key-file=/opt/kubernetes/tls/kubelet-key.pem"
KUBELET_CNI_ARGS="--network-plugin=cni --cni-conf-dir=/opt/kubernetes/cni/net.d --cni-bin-dir=/opt/kubernetes/cni/bin"

# Add your own!
KUBELET_EXTRA_ARGS="--cluster-dns=10.65.0.100 \
  --kubeconfig=/opt/kubernetes/etc/kubeconfig.conf \
  --cluster-domain=cluster.local \
  --cgroup-driver=cgroupfs \
  --fail-swap-on=false \
  --image-gc-high-threshold=95 \
  --image-gc-low-threshold=80 \
  --serialize-image-pulls=false \
  --max-pods=30 \
  --container-runtime=docker \
  --cloud-provider='' \
  --container-log-max-size=50Mi \
  --container-log-max-files=5 \
  --feature-gates=CRIContainerLogRotation=true \
  --runtime-cgroups=/sys/fs/cgroup/systemd/user.slice/user-1000.slice/session-49.scope \
  --root-dir=/opt/kubernetes/kubelet \
  --container-runtime-endpoint=unix:///opt/kubernetes/run/dockershim.sock"

KUBE_ARGS="\
  ${KUBELET_ADDRESS:?undef} \
  ${KUBELET_PORT:?undef} \
  ${KUBELET_HOSTNAME:?undef} \
  ${KUBELET_POD_INFRA_CONTAINER:?undef} \
  ${KUBELET_LOG_ARGS:?undef} \
  ${KUBELET_TLS_ARGS:?undef} \
  ${KUBELET_CNI_ARGS:?undef} \
  ${KUBELET_EXTRA_ARGS:?undef}" 
