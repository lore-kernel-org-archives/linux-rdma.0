From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH/libnes] Fix build against upstream libibverbs
Date: Thu,  5 May 2011 13:35:56 -0700
Message-ID: <1304627756-13446-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Upstream libibverbs has not merged support for IBV_QPT_RAW_ETH yet.
Add a test for the identifier to the configure script, and add #ifdefs
to compile raw Ethernet QP support only if libibverbs supports it.

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 configure.in     |    2 ++
 src/nes_uverbs.c |   16 +++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

Index: libnes-1.1.1/configure.in
===================================================================
--- libnes-1.1.1.orig/configure.in	2011-05-05 12:10:43.810368012 -0700
+++ libnes-1.1.1/configure.in	2011-05-05 12:11:13.990515182 -0700
@@ -38,6 +38,8 @@
 AC_C_CONST
 AC_CHECK_SIZEOF(long)
 
+AC_CHECK_DECLS([IBV_QPT_RAW_ETH])
+
 dnl Checks for library functions
 AC_CHECK_FUNCS(ibv_read_sysfs_file ibv_register_driver)
 
Index: libnes-1.1.1/src/nes_uverbs.c
===================================================================
--- libnes-1.1.1.orig/src/nes_uverbs.c	2011-05-05 12:11:20.280547877 -0700
+++ libnes-1.1.1/src/nes_uverbs.c	2011-05-05 12:12:59.411140500 -0700
@@ -1125,12 +1125,16 @@
 	int i = 0;
 
 	/* fprintf(stderr, PFX "%s\n", __FUNCTION__); */
+
+#if HAVE_DECL_IBV_QPT_RAW_ETH
 	if (attr->qp_type == IBV_QPT_RAW_ETH) {
 		attr->cap.max_send_sge = NES_UD_MAX_SG_LIST_SZ;
 		attr->cap.max_recv_sge = NES_UD_MAX_SG_LIST_SZ;
 		nes_debug(NES_DBG_UD, "%s(%d) patching max_sge for UD\n",
 				__func__, __LINE__);
 	}
+#endif
+
 	/* Sanity check QP size before proceeding */
 	sqdepth = nes_qp_get_qdepth(attr->cap.max_send_wr, attr->cap.max_send_sge);
 	if (!sqdepth) {
@@ -1186,6 +1190,7 @@
 	nesuqp->nes_drv_opt = resp.nes_drv_opt;
 	nesuqp->ibv_qp.qp_num = resp.qp_id;
 
+#if HAVE_DECL_IBV_QPT_RAW_ETH
 	if (attr->qp_type == IBV_QPT_RAW_ETH) {
 		nesuqp->nes_ud_sksq_fd = open("/dev/infiniband/nes_ud_sksq",
 						O_RDWR);
@@ -1233,6 +1238,8 @@
 		memset(&nesuqp->send_wr_id[0], 0, sizeof(uint64_t) * 512);
 		memset(&nesuqp->recv_wr_id[0], 0, sizeof(uint64_t) * 512);
 	}
+#endif
+
 	return &nesuqp->ibv_qp;
 }
 
@@ -1324,6 +1331,8 @@
 	}
 
 	pthread_spin_destroy(&nesuqp->lock);
+
+#if HAVE_DECL_IBV_QPT_RAW_ETH
 	if (qp->qp_type == IBV_QPT_RAW_ETH) {
 		if (nesuqp->pend_rx_wr) {
 			for (i = 0; i < NES_UD_RX_BATCH_SZ; i++)
@@ -1340,6 +1349,8 @@
 		nesuqp->sksq_shared_ctxt = 0;
 		close(nesuqp->nes_ud_sksq_fd);
 	}
+#endif
+
 	/* Clean any pending completions from the cq(s) */
 	if (nesuqp->send_cq)
 		nes_clean_cq(nesuqp, nesuqp->send_cq);
@@ -1447,8 +1458,10 @@
 	uint32_t total_payload_length = 0;
 	int sge_index;
 
+#if HAVE_DECL_IBV_QPT_RAW_ETH
 	if (ib_qp->qp_type == IBV_QPT_RAW_ETH)
 		return nes_ima_upost_send(ib_qp, ib_wr, bad_wr);
+#endif
 
 	pthread_spin_lock(&nesuqp->lock);
 
@@ -1715,9 +1728,10 @@
 	uint32_t total_payload_length;
 	int sge_index;
 
-
+#if HAVE_DECL_IBV_QPT_RAW_ETH
 	if (ib_qp->qp_type == IBV_QPT_RAW_ETH)
 		return nes_ima_upost_recv(ib_qp, ib_wr, bad_wr);
+#endif
 
 	if (unlikely(ib_wr->num_sge > 4)) {
 		*bad_wr = ib_wr;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
