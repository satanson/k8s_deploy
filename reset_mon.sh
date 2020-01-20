#!/bin/bash

systemctl stop ceph-mon@$(hostname -s)
systemctl stop ceph-mon@.service
systemctl stop ceph-mon.target

systemctl disable ceph-mon@$(hostname -s)
systemctl disable ceph-mon@.service
systemctl disable ceph-mon.target

systemctl enable /opt/ceph_scripts/ceph-mon.target
systemctl enable /opt/ceph_scripts/ceph-mon@.service
systemctl enable ceph-mon@$(hostname -s)

systemctl start ceph-mon.target
docker ps -a
systemctl status ceph-mon.target
systemctl |grep ceph-mon
