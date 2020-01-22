# Deploying Kubernetes manually for chewing source code


## Environement

- 3 VMs fetched by vagrant; 
- OS: provisioned hashicorp/bionic64, i.e. ubuntu 18.04;
- hostnames&IPs: k8s-139-{10..12}, 192.168.139.{10..12}

## Howto

### 1. bootstrap a new k8s cluster 

```bash
./deploy_etcd.sh
./kube_do.sh # select path: cluster=>bootstrap
cp kubernetes_etc/config ${HOME}/.kube/
kubectl create -f coredns.yaml
```

### 2. teardown a old k8s cluster

```bash
./kube_do.sh # select path: cluster=>teardown
```

### 3. try other options

```bash
./kube_do.sh # interactive script
```
