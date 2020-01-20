#!/bin/bash
cp /tmp/id_rsa_vagrant /home/vagrant/.ssh/
cat /tmp/id_rsa_vagrant.pub >>/home/vagrant/.ssh/authorized_keys
chmod -R 750 /home/vagrant/.ssh
chmod -R 640 /home/vagrant/.ssh/*
