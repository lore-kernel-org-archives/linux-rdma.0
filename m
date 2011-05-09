From: bhavinkumar thumar <bhawinkumar.thumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Building and Installing SDP on existing OFED 1.5.2 install
Date: Mon, 9 May 2011 13:52:04 +0530
Message-ID: <BANLkTimvikSV-B5503wNBBumB2D274m=vQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

I have downloaded the OFED 1.5.2 tar file and then installed RPM
source files to /usr/src/redhat/SOURCES. Now I changed some portion of
sdp_main.c and then I performed following steps.

#cd /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/

#./configure --with-core-mod --with-ipoib-mod --with-mthca-mod
--with-mlx4_core-mod --with-mlx4_inf-mod --with-sdp-mod
--with-sdp_debug-mod
- Succeed

#make
- Succeed

#make install
- Succeed

make[1]: Entering directory `/usr/src/kernels/2.6.18-194.el5-x86_64'
  INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniband/core/ib_cm.ko
  INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniband/core/ib_core.ko
  INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniband/core/ib_mad.ko
  INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniband/core/ib_sa.ko
  INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniband/core/iw_cm.ko
  INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniband/hw/mlx4/mlx4_ib.ko
  INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniband/hw/mthca/ib_mthca.ko
  INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniband/ulp/ipoib/ib_ipoib.ko
  INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniband/ulp/ipoib/ipoib_helper.ko
  INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/infiniband/ulp/sdp/ib_sdp.ko
  INSTALL /usr/src/redhat/SOURCES/ofa_kernel-1.5.2/drivers/net/mlx4/mlx4_core.ko
  DEPMOD  2.6.18-194.el5

#modprobe ib_sdp
- FATAL: Error inserting ib_sdp
(/lib/modules/2.6.18-194.el5/updates/kernel/drivers/infiniband/ulp/sdp/ib_sdp.ko):
Unknown symbol in module, or unknown parameter (see dmesg)

#dmesg
mtrr: no more MTRRs available
mtrr: no more MTRRs available
mtrr: no more MTRRs available
mtrr: no more MTRRs available
mtrr: no more MTRRs available
mtrr: no more MTRRs available
mtrr: no more MTRRs available
mtrr: no more MTRRs available
rdma_cm: disagrees about version of symbol ib_send_cm_sidr_req
rdma_cm: Unknown symbol ib_send_cm_sidr_req
rdma_cm: disagrees about version of symbol iw_create_cm_id
rdma_cm: Unknown symbol iw_create_cm_id
rdma_cm: disagrees about version of symbol ib_unregister_client
rdma_cm: Unknown symbol ib_unregister_client
rdma_cm: disagrees about version of symbol ib_send_cm_sidr_rep
rdma_cm: Unknown symbol ib_send_cm_sidr_rep
rdma_cm: disagrees about version of symbol ib_cm_listen
rdma_cm: Unknown symbol ib_cm_listen
rdma_cm: disagrees about version of symbol ib_destroy_cm_id
rdma_cm: Unknown symbol ib_destroy_cm_id
rdma_cm: disagrees about version of symbol ib_find_cached_pkey
rdma_cm: Unknown symbol ib_find_cached_pkey
rdma_cm: disagrees about version of symbol iw_cm_connect
rdma_cm: Unknown symbol iw_cm_connect
rdma_cm: disagrees about version of symbol ib_cm_notify
rdma_cm: Unknown symbol ib_cm_notify
rdma_cm: disagrees about version of symbol ib_detach_mcast
rdma_cm: Unknown symbol ib_detach_mcast
rdma_cm: disagrees about version of symbol ib_sa_get_mcmember_rec
rdma_cm: Unknown symbol ib_sa_get_mcmember_rec
rdma_cm: disagrees about version of symbol ib_sa_cancel_query
rdma_cm: Unknown symbol ib_sa_cancel_query
rdma_cm: disagrees about version of symbol ib_register_client
rdma_cm: Unknown symbol ib_register_client
rdma_cm: disagrees about version of symbol ib_sa_path_rec_get
rdma_cm: Unknown symbol ib_sa_path_rec_get
rdma_cm: disagrees about version of symbol ib_create_cm_id
rdma_cm: Unknown symbol ib_create_cm_id

................................................

rdma_cm: disagrees about version of symbol ib_init_ah_from_path
rdma_cm: Unknown symbol ib_init_ah_from_path
rdma_cm: disagrees about version of symbol ib_destroy_qp
rdma_cm: Unknown symbol ib_destroy_qp
rdma_cm: disagrees about version of symbol iw_cm_init_qp_attr
rdma_cm: Unknown symbol iw_cm_init_qp_attr
rdma_cm: disagrees about version of symbol ib_send_cm_rtu
rdma_cm: Unknown symbol ib_send_cm_rtu
rdma_cm: disagrees about version of symbol ib_send_cm_dreq
rdma_cm: Unknown symbol ib_send_cm_dreq
rdma_cm: disagrees about version of symbol ib_send_cm_req
rdma_cm: Unknown symbol ib_send_cm_req
rdma_cm: disagrees about version of symbol ib_sa_join_multicast
rdma_cm: Unknown symbol ib_sa_join_multicast
rdma_cm: disagrees about version of symbol ib_attach_mcast
rdma_cm: Unknown symbol ib_attach_mcast
rdma_cm: disagrees about version of symbol ib_find_cached_gid
rdma_cm: Unknown symbol ib_find_cached_gid
rdma_cm: disagrees about version of symbol iw_cm_listen
rdma_cm: Unknown symbol iw_cm_listen
rdma_cm: disagrees about version of symbol ib_send_cm_rej
rdma_cm: Unknown symbol ib_send_cm_rej


can anyone tell me what's wrong? Please help me.


Thanking You,
Bhavin
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
