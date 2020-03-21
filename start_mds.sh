#!/bin/bash
sudo systemctl disable ceph-mds.target
sudo systemctl disable ceph-mds@.service
sudo systemctl disable ceph-mds@k8s-139-10

#sudo systemctl enable /opt/ceph_scripts/ceph-mds.target
#sudo systemctl enable /opt/ceph_scripts/ceph-mds@.service
#
#sudo systemctl start ceph-mds@k8s-139-10
#
#sudo docker ps -a |grep ceph
#sudo systemctl |grep ceph-mds
#sudo systemctl status ceph-mds@k8s-139-10
#
#sudo systemctl stop ceph-mds.target
#sudo docker ps -a |grep ceph
#sudo systemctl |grep ceph-mds
#sudo systemctl status ceph-mds@k8s-139-10
#
#sudo systemctl stop ceph-mds.target
#sudo docker ps -a |grep ceph
#sudo systemctl |grep ceph-mds
#sudo systemctl status ceph-mds@k8s-139-10
