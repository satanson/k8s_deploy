#!/bin/bash
[ -d kubernetes_tls ] && rm -fr kubernetes_tls
mkdir -p kubernetes_tls
cp ca.pem kubernetes_tls
for role in apiserver scheduler controller-manager kubelet kubeproxy kubectl;do
  cfssl gencert -ca ca.pem -ca-key ca-key.pem -config ca-config.json -profile kubernetes ${role}-csr.json |cfssljson -bare ${role}
  cp ${role}.pem kubernetes_tls
  cp ${role}-key.pem kubernetes_tls
done
#openssl x509 -in ca.pem -text -noout
