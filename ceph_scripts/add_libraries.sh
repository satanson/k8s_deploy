#!/bin/bash

sudo mkdir -p /usr/local/lib
sudo mkdir -p /usr/local/lib/ceph/compressor
sudo mkdir -p /usr/local/lib/ceph/crypto
sudo mkdir -p /usr/local/lib/ceph/erasure-code
sudo mkdir -p /usr/local/lib/rados-classes
sudo mkdir -p /usr/local/share/ceph

sudo ln -sf /home/grakra/workspace/ceph/src/pybind/mgr /usr/local/share/ceph/mgr
sudo ln -sf /home/grakra/workspace/ceph/build/lib/cython_modules/lib.2/rados.so /usr/local/lib/python2.7/site-packages/rados.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/cython_modules/lib.2/cephfs.so /usr/local/lib/python2.7/site-packages/cephfs.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/cython_modules/lib.2/rbd.so /usr/local/lib/python2.7/site-packages/rbd.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/cython_modules/lib.2/rgw.so /usr/local/lib/python2.7/site-packages/rgw.so

sudo ln -sf /home/grakra/workspace/ceph/build/lib/libosd_tp.so /usr/local/lib/libosd_tp.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/librados.so /usr/local/lib/librados.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libec_shec_sse3.so /usr/local/lib/ceph/erasure-code/libec_shec_sse3.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libec_jerasure.so /usr/local/lib/ceph/erasure-code/libec_jerasure.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libec_shec_generic.so /usr/local/lib/ceph/erasure-code/libec_shec_generic.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libec_shec_sse4.so /usr/local/lib/ceph/erasure-code/libec_shec_sse4.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libec_lrc.so /usr/local/lib/ceph/erasure-code/libec_lrc.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libec_shec.so /usr/local/lib/ceph/erasure-code/libec_shec.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libec_jerasure_generic.so /usr/local/lib/ceph/erasure-code/libec_jerasure_generic.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libec_jerasure_sse4.so /usr/local/lib/ceph/erasure-code/libec_jerasure_sse4.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libec_clay.so /usr/local/lib/ceph/erasure-code/libec_clay.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libec_jerasure_sse3.so /usr/local/lib/ceph/erasure-code/libec_jerasure_sse3.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libec_isa.so /usr/local/lib/ceph/erasure-code/libec_isa.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libceph_snappy.so /usr/local/lib/ceph/compressor/libceph_snappy.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libceph_lz4.so /usr/local/lib/ceph/compressor/libceph_lz4.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libceph_zstd.so /usr/local/lib/ceph/compressor/libceph_zstd.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libceph_zlib.so /usr/local/lib/ceph/compressor/libceph_zlib.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libceph_crypto_isal.so /usr/local/lib/ceph/crypto/libceph_crypto_isal.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libceph_crypto_openssl.so /usr/local/lib/ceph/crypto/libceph_crypto_openssl.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/librgw.so /usr/local/lib/librgw.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/librbd.so /usr/local/lib/librbd.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libcephfs.so /usr/local/lib/libcephfs.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libcls_hello.so /usr/local/lib/rados-classes/libcls_hello.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libcls_rbd.so /usr/local/lib/rados-classes/libcls_rbd.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libcls_log.so /usr/local/lib/rados-classes/libcls_log.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libcls_rgw.so /usr/local/lib/rados-classes/libcls_rgw.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libcls_cas.so /usr/local/lib/rados-classes/libcls_cas.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libcls_otp.so /usr/local/lib/rados-classes/libcls_otp.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libcls_lua.so /usr/local/lib/rados-classes/libcls_lua.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libcls_numops.so /usr/local/lib/rados-classes/libcls_numops.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libcls_refcount.so /usr/local/lib/rados-classes/libcls_refcount.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libcls_lock.so /usr/local/lib/rados-classes/libcls_lock.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libcls_user.so /usr/local/lib/rados-classes/libcls_user.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libcls_journal.so /usr/local/lib/rados-classes/libcls_journal.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libcls_kvs.so /usr/local/lib/rados-classes/libcls_kvs.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libcls_cephfs.so /usr/local/lib/rados-classes/libcls_cephfs.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libcls_timeindex.so /usr/local/lib/rados-classes/libcls_timeindex.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libcls_version.so /usr/local/lib/rados-classes/libcls_version.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libcls_sdk.so /usr/local/lib/rados-classes/libcls_sdk.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/librbd_tp.so /usr/local/lib/librbd_tp.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/librgw_rados_tp.so /usr/local/lib/librgw_rados_tp.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/librgw_op_tp.so /usr/local/lib/librgw_op_tp.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libradosstriper.so /usr/local/lib/libradosstriper.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/librados_tp.so /usr/local/lib/librados_tp.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/librgw_admin_user.so /usr/local/lib/librgw_admin_user.so
sudo ln -sf /home/grakra/workspace/ceph/build/lib/libos_tp.so /usr/local/lib/libos_tp.so
