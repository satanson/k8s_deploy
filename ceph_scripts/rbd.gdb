set args pool init  -c /etc/ceph/ceph.conf --id admin -k /etc/ceph/ceph.client.admin.keyring
start
set breakpoint pending on
br PoolMetadata.cc:95
continue
br PoolMetadata.cc:97
continue
br cls_rbd_client.cc:1456
continue
br cls_rbd_client.cc:1459
continue
br librados_cxx.cc:1419
continue
br IoCtxImpl.cc:718
continue
br IoCtxImpl.cc:721
continue
br SubsystemMap.h:84
br SubsystemMap.h:90
continue
