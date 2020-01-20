#!/bin/bash

hostList=${1:?"missing 'hostList'"};shift
dockerUrl=${1:?"missing 'dockerUrl'"};shift
user=${1:?"missing 'user'"};shift
password=${1:?"missing 'user'"};shift

./upload.sh ${hostList} ca.crt

cat >scripts/add_ca.sh  <<DONE
#!/bin/bash
set -e -o pipefail
sudo mkdir -p /etc/docker/certs.d/${dockerUrl}/
sudo cp /tmp/ca.crt  /etc/docker/certs.d/${dockerUrl}/
sudo systemctl restart docker
sudo docker login -u ${user} -p ${password} ${dockerUrl}
DONE

./doall_script.sh ${hostList} scripts/add_ca.sh
