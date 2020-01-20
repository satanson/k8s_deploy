#!/bin/bash

hostList=${1:?"missing 'hostList'"};shift

cat >scripts/daemon.json <<'DONE'
{
	"storage-driver": "overlay2",
	"log-opts": {
		"max-size": "200m",
		"max-file": "5"
	},
	"log-level": "warn",
	"registry-mirrors": [
		"https://registry.docker-cn.com",
		"http://hub-mirror.c.163.com"
	]
}
DONE

cat >scripts/change_daemon.sh <<'DONE'
#!/bin/bash
sudo cp /tmp/daemon.json /etc/docker/daemon.json
sudo systemctl restart docker
sudo docker ps -a 
DONE
./upload.sh ${hostList} scripts/daemon.json
./doall_script.sh ${hostList} scripts/change_daemon.sh
