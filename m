From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC rdma-core 3/3] qedr: Use common provider debug macros
Date: Tue, 17 Jan 2017 13:48:14 -0600
Message-ID: <1484682494-76200-1-git-send-email-tatyana.e.nikolova@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Replace qedr specific debug macros with
common provider macros.

Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 providers/qedr/qelr.h       |  57 +--------------
 providers/qedr/qelr_main.c  |  68 +++---------------
 providers/qedr/qelr_verbs.c | 168 +++++++++++++++++++++++++-------------------
 3 files changed, 107 insertions(+), 186 deletions(-)

diff --git a/providers/qedr/qelr.h b/providers/qedr/qelr.h
index e2a9248..b544616 100644
--- a/providers/qedr/qelr.h
+++ b/providers/qedr/qelr.h
@@ -37,6 +37,7 @@
 #include <stddef.h>
 #include <endian.h>
 #include <ccan/minmax.h>
+#include <util/dbg.h>
 
 #include <infiniband/driver.h>
 #include <infiniband/arch.h>
@@ -47,62 +48,6 @@
 #include "qelr_hsi.h"
 #include "qelr_chain.h"
 
-#define qelr_err(format, arg...) printf(format, ##arg)
-
-extern uint32_t qelr_dp_level;
-extern uint32_t qelr_dp_module;
-
-enum DP_MODULE {
-	QELR_MSG_CQ		= 0x10000,
-	QELR_MSG_RQ		= 0x20000,
-	QELR_MSG_SQ		= 0x40000,
-	QELR_MSG_QP		= (QELR_MSG_SQ | QELR_MSG_RQ),
-	QELR_MSG_MR		= 0x80000,
-	QELR_MSG_INIT		= 0x100000,
-	/* to be added...up to 0x8000000 */
-};
-
-enum DP_LEVEL {
-	QELR_LEVEL_VERBOSE	= 0x0,
-	QELR_LEVEL_INFO		= 0x1,
-	QELR_LEVEL_NOTICE	= 0x2,
-	QELR_LEVEL_ERR		= 0x3,
-};
-
-#define DP_ERR(fd, fmt, ...)					\
-do {								\
-	fprintf(fd, "[%s:%d]" fmt,				\
-		__func__, __LINE__,				\
-		##__VA_ARGS__);					\
-	fflush(fd); \
-} while (0)
-
-#define DP_NOTICE(fd, fmt, ...)					\
-do {								\
-	if (qelr_dp_level <= QELR_LEVEL_NOTICE)	{\
-		fprintf(fd, "[%s:%d]" fmt,			\
-		      __func__, __LINE__,			\
-		      ##__VA_ARGS__);				\
-		      fflush(fd); }				\
-} while (0)
-
-#define DP_INFO(fd, fmt, ...)					\
-do {								\
-	if (qelr_dp_level <= QELR_LEVEL_INFO)	{		\
-		fprintf(fd, "[%s:%d]" fmt,			\
-		      __func__, __LINE__,			\
-		      ##__VA_ARGS__); fflush(fd);		\
-	}							\
-} while (0)
-
-#define DP_VERBOSE(fd, module, fmt, ...)			\
-do {								\
-	if ((qelr_dp_level <= QELR_LEVEL_VERBOSE) &&		\
-		     (qelr_dp_module & (module))) {		\
-		fprintf(fd, "[%s:%d]" fmt,			\
-		      __func__, __LINE__,			\
-		      ##__VA_ARGS__);	fflush(fd); }		\
-} while (0)
 
 struct qelr_buf {
 	void		*addr;
diff --git a/providers/qedr/qelr_main.c b/providers/qedr/qelr_main.c
index 0378d2c..cfa3c79 100644
--- a/providers/qedr/qelr_main.c
+++ b/providers/qedr/qelr_main.c
@@ -119,53 +119,6 @@ static struct ibv_device_ops qelr_dev_ops = {
 	.free_context = qelr_free_context
 };
 
-static void qelr_open_debug_file(struct qelr_devctx *ctx)
-{
-	char *env;
-
-	env = getenv("QELR_DEBUG_FILE");
-	if (!env) {
-		ctx->dbg_fp = stderr;
-		DP_VERBOSE(ctx->dbg_fp, QELR_MSG_INIT,
-			   "Debug file opened: stderr\n");
-		return;
-	}
-
-	ctx->dbg_fp = fopen(env, "aw+");
-	if (!ctx->dbg_fp) {
-		fprintf(stderr, "Failed opening debug file %s, using stderr\n",
-			env);
-		ctx->dbg_fp = stderr;
-		DP_VERBOSE(ctx->dbg_fp, QELR_MSG_INIT,
-			   "Debug file opened: stderr\n");
-		return;
-	}
-
-	DP_VERBOSE(ctx->dbg_fp, QELR_MSG_INIT, "Debug file opened: %s\n", env);
-}
-
-static void qelr_close_debug_file(struct qelr_devctx *ctx)
-{
-	if (ctx->dbg_fp && ctx->dbg_fp != stderr)
-		fclose(ctx->dbg_fp);
-}
-
-static void qelr_set_debug_mask(void)
-{
-	char *env;
-
-	qelr_dp_level = QELR_LEVEL_NOTICE;
-	qelr_dp_module = 0;
-
-	env = getenv("QELR_DP_LEVEL");
-	if (env)
-		qelr_dp_level = atoi(env);
-
-	env = getenv("QELR_DP_MODULE");
-	if (env)
-		qelr_dp_module = atoi(env);
-}
-
 static struct ibv_context *qelr_alloc_context(struct ibv_device *ibdev,
 					      int cmd_fd)
 {
@@ -180,8 +133,10 @@ static struct ibv_context *qelr_alloc_context(struct ibv_device *ibdev,
 
 	ctx->ibv_ctx.cmd_fd = cmd_fd;
 
-	qelr_open_debug_file(ctx);
-	qelr_set_debug_mask();
+	setup_debug();
+	ctx->dbg_fp = open_debug_file();
+	if (!ctx->dbg_fp)
+		ctx->dbg_fp = stderr;
 
 	if (ibv_cmd_get_context(&ctx->ibv_ctx,
 				(struct ibv_get_context *)&cmd, sizeof(cmd),
@@ -205,17 +160,17 @@ static struct ibv_context *qelr_alloc_context(struct ibv_device *ibdev,
 	if (ctx->db_addr == MAP_FAILED) {
 		int errsv = errno;
 
-		DP_ERR(ctx->dbg_fp,
-		       "alloc context: doorbell mapping failed resp.db_pa = %llx resp.db_size=%d context->cmd_fd=%d errno=%d\n",
-		       resp.db_pa, resp.db_size, cmd_fd, errsv);
+		PRINT_ERR("alloc context: doorbell mapping failed resp.db_pa = %llx "
+				"resp.db_size=%d context->cmd_fd=%d errno=%d\n",
+				resp.db_pa, resp.db_size, cmd_fd, errsv);
 		goto cmd_err;
 	}
 
 	return &ctx->ibv_ctx;
 
 cmd_err:
-	qelr_err("%s: Failed to allocate context for device.\n", __func__);
-	qelr_close_debug_file(ctx);
+	PRINT_ERR("Failed to allocate context for device.\n");
+	close_debug_file(ctx->dbg_fp);
 	free(ctx);
 	return NULL;
 }
@@ -227,7 +182,7 @@ static void qelr_free_context(struct ibv_context *ibctx)
 	if (ctx->db_addr)
 		munmap(ctx->db_addr, ctx->db_size);
 
-	qelr_close_debug_file(ctx);
+	close_debug_file(ctx->dbg_fp);
 	free(ctx);
 }
 
@@ -267,8 +222,7 @@ found:
 
 	dev = malloc(sizeof(*dev));
 	if (!dev) {
-		qelr_err("%s() Fatal: fail allocate device for libqedr\n",
-			 __func__);
+		PRINT_ERR("Fatal: fail allocate device for libqedr\n");
 		return NULL;
 	}
 
diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
index 793b1f4..95ac49f 100644
--- a/providers/qedr/qelr_verbs.c
+++ b/providers/qedr/qelr_verbs.c
@@ -54,10 +54,6 @@
 #include <stdlib.h>
 #include <execinfo.h>
 
-/* Fast path debug prints */
-#define FP_DP_VERBOSE(...)
-/* #define FP_DP_VERBOSE(...)	DP_VERBOSE(__VA_ARGS__) */
-
 #define QELR_SQE_ELEMENT_SIZE	(sizeof(struct rdma_sq_sge))
 #define QELR_RQE_ELEMENT_SIZE	(sizeof(struct rdma_rq_sge))
 #define QELR_CQE_SIZE		(sizeof(union rdma_cqe))
@@ -128,7 +124,8 @@ struct ibv_pd *qelr_alloc_pd(struct ibv_context *context)
 
 	pd->pd_id = resp.pd_id;
 
-	DP_VERBOSE(cxt->dbg_fp, QELR_MSG_INIT, "Allocated pd: %d\n", pd->pd_id);
+	LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_PD, VERBS_DBG_LEVEL_VERBOSE,
+			"Allocated pd: %d\n", pd->pd_id);
 
 	return &pd->ibv_pd;
 }
@@ -139,8 +136,8 @@ int qelr_dealloc_pd(struct ibv_pd *ibpd)
 	struct qelr_pd *pd = get_qelr_pd(ibpd);
 	struct qelr_devctx *cxt = get_qelr_ctx(ibpd->context);
 
-	DP_VERBOSE(cxt->dbg_fp, QELR_MSG_INIT, "Deallocated pd: %d\n",
-		   pd->pd_id);
+	LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_PD, VERBS_DBG_LEVEL_VERBOSE,
+			"Deallocated pd: %d\n", pd->pd_id);
 
 	rc = ibv_cmd_dealloc_pd(ibpd);
 
@@ -176,7 +173,7 @@ struct ibv_mr *qelr_reg_mr(struct ibv_pd *ibpd, void *addr,
 		return NULL;
 	}
 
-	DP_VERBOSE(cxt->dbg_fp, QELR_MSG_MR,
+	LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_MR, VERBS_DBG_LEVEL_VERBOSE,
 		   "MR Register %p completed succesfully pd_id=%d addr=%p len=%zu access=%d lkey=%x rkey=%x\n",
 		   mr, pd->pd_id, addr, len, access, mr->ibv_mr.lkey,
 		   mr->ibv_mr.rkey);
@@ -195,7 +192,7 @@ int qelr_dereg_mr(struct ibv_mr *mr)
 
 	free(mr);
 
-	DP_VERBOSE(cxt->dbg_fp, QELR_MSG_MR,
+	LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_MR, VERBS_DBG_LEVEL_VERBOSE,
 		   "MR DERegister %p completed succesfully\n", mr);
 	return 0;
 }
@@ -225,12 +222,12 @@ struct ibv_cq *qelr_create_cq(struct ibv_context *context, int cqe,
 	int chain_size;
 	int rc;
 
-	DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
+	LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_CQ, VERBS_DBG_LEVEL_VERBOSE,
 		   "create cq: context=%p, cqe=%d, channel=%p, comp_vector=%d\n",
 		   context, cqe, channel, comp_vector);
 
 	if (!cqe || cqe > cxt->max_cqes) {
-		DP_ERR(cxt->dbg_fp,
+		LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
 		       "create cq: failed. attempted to allocate %d cqes but valid range is 1...%d\n",
 		       cqe, cqe > cxt->max_cqes);
 		return NULL;
@@ -254,7 +251,8 @@ struct ibv_cq *qelr_create_cq(struct ibv_context *context, int cqe,
 			       &cq->ibv_cq, &cmd.ibv_cmd, sizeof(cmd),
 			       &resp.ibv_resp, sizeof(resp));
 	if (rc) {
-		DP_ERR(cxt->dbg_fp, "create cq: failed with rc = %d\n", rc);
+		LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
+				"create cq: failed with rc = %d\n", rc);
 		goto err_1;
 	}
 
@@ -270,7 +268,7 @@ struct ibv_cq *qelr_create_cq(struct ibv_context *context, int cqe,
 	cq->latest_cqe = NULL; /* must be different from chain_toggle */
 	consume_cqe(cq);
 
-	DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
+	LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_CQ, VERBS_DBG_LEVEL_VERBOSE,
 		   "create cq: successfully created %p\n", cq);
 
 	return &cq->ibv_cq;
@@ -289,11 +287,12 @@ int qelr_destroy_cq(struct ibv_cq *ibv_cq)
 	struct qelr_cq *cq = get_qelr_cq(ibv_cq);
 	int rc;
 
-	DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ, "destroy cq: %p\n", cq);
+	LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_CQ, VERBS_DBG_LEVEL_VERBOSE,
+			"destroy cq: %p\n", cq);
 
 	rc = ibv_cmd_destroy_cq(ibv_cq);
 	if (rc) {
-		DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
+		LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_CQ, VERBS_DBG_LEVEL_VERBOSE,
 		           "destroy cq: failed to destroy %p, got %d.\n", cq,
 			   rc);
 		return rc;
@@ -302,7 +301,7 @@ int qelr_destroy_cq(struct ibv_cq *ibv_cq)
 	qelr_chain_free(&cq->chain);
 	free(cq);
 
-	DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
+	LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_CQ, VERBS_DBG_LEVEL_VERBOSE,
 		   "destroy cq: successfully destroyed %p\n", cq);
 
 	return 0;
@@ -347,7 +346,8 @@ static inline int qelr_create_qp_buffers_sq(struct qelr_devctx *cxt,
 	rc = qelr_chain_alloc(&qp->sq.chain, chain_size, cxt->kernel_page_size,
 			      QELR_SQE_ELEMENT_SIZE);
 	if (rc)
-		DP_ERR(cxt->dbg_fp, "create qp: failed to map SQ, got %d", rc);
+		LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
+				"create qp: failed to map SQ, got %d", rc);
 
 	qp->sq.max_wr = max_send_wr;
 	qp->sq.max_sges = cxt->sges_per_send_wr;
@@ -376,7 +376,8 @@ static inline int qelr_create_qp_buffers_rq(struct qelr_devctx *cxt,
 	rc = qelr_chain_alloc(&qp->rq.chain, chain_size, cxt->kernel_page_size,
 			      QELR_RQE_ELEMENT_SIZE);
 	if (rc)
-		DP_ERR(cxt->dbg_fp, "create qp: failed to map RQ, got %d", rc);
+		LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
+				"create qp: failed to map RQ, got %d", rc);
 
 	qp->rq.max_wr = max_recv_wr;
 	qp->rq.max_sges = cxt->sges_per_recv_wr;
@@ -417,7 +418,7 @@ static inline int qelr_configure_qp_sq(struct qelr_devctx *cxt,
 	/* shadow SQ */
 	qp->wqe_wr_id = calloc(qp->sq.max_wr, sizeof(*qp->wqe_wr_id));
 	if (!qp->wqe_wr_id) {
-		DP_ERR(cxt->dbg_fp,
+		LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
 		       "create qp: failed shdow SQ memory allocation\n");
 		return -ENOMEM;
 	}
@@ -438,7 +439,7 @@ static inline int qelr_configure_qp_rq(struct qelr_devctx *cxt,
 	/* shadow RQ */
 	qp->rqe_wr_id = calloc(qp->rq.max_wr, sizeof(*qp->rqe_wr_id));
 	if (!qp->rqe_wr_id) {
-		DP_ERR(cxt->dbg_fp,
+		LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
 		       "create qp: failed shdow RQ memory allocation\n");
 		return -ENOMEM;
 	}
@@ -473,7 +474,7 @@ static inline void qelr_print_qp_init_attr(
 		struct qelr_devctx *cxt,
 		struct ibv_qp_init_attr *attr)
 {
-	DP_VERBOSE(cxt->dbg_fp, QELR_MSG_QP,
+	LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_QP, VERBS_DBG_LEVEL_VERBOSE,
 		   "create qp: send_cq=%p, recv_cq=%p, srq=%p, max_inline_data=%d, max_recv_sge=%d, max_recv_wr=%d, max_send_sge=%d, max_send_wr=%d, qp_type=%d, sq_sig_all=%d\n",
 		   attr->send_cq, attr->recv_cq, attr->srq,
 		   attr->cap.max_inline_data, attr->cap.max_recv_sge,
@@ -532,7 +533,7 @@ struct ibv_qp *qelr_create_qp(struct ibv_pd *pd,
 	rc = ibv_cmd_create_qp(pd, &qp->ibv_qp, attrs, &req.ibv_qp, sizeof(req),
 			       &resp.ibv_resp, sizeof(resp));
 	if (rc) {
-		DP_ERR(cxt->dbg_fp,
+		LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
 		       "create qp: failed on ibv_cmd_create_qp with %d\n", rc);
 		goto err1;
 	}
@@ -541,7 +542,7 @@ struct ibv_qp *qelr_create_qp(struct ibv_pd *pd,
 	if (rc)
 		goto err2;
 
-	DP_VERBOSE(cxt->dbg_fp, QELR_MSG_QP,
+	LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_QP, VERBS_DBG_LEVEL_VERBOSE,
 		   "create qp: successfully created %p. handle_hi=%x handle_lo=%x\n",
 		   qp, req.qp_handle_hi, req.qp_handle_lo);
 
@@ -550,7 +551,8 @@ struct ibv_qp *qelr_create_qp(struct ibv_pd *pd,
 err2:
 	rc = ibv_cmd_destroy_qp(&qp->ibv_qp);
 	if (rc)
-		DP_ERR(cxt->dbg_fp, "create qp: fatal fault. rc=%d\n", rc);
+		LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
+				"create qp: fatal fault. rc=%d\n", rc);
 err1:
 	qelr_chain_free_sq(qp);
 	qelr_chain_free_rq(qp);
@@ -562,7 +564,7 @@ err0:
 
 static void qelr_print_ah_attr(struct qelr_devctx *cxt, struct ibv_ah_attr *attr)
 {
-	DP_VERBOSE(cxt->dbg_fp, QELR_MSG_QP,
+	LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_QP, VERBS_DBG_LEVEL_VERBOSE,
 		   "grh.dgid=[%#" PRIx64 ":%#" PRIx64 "], grh.flow_label=%d, grh.sgid_index=%d, grh.hop_limit=%d, grh.traffic_class=%d, dlid=%d, sl=%d, src_path_bits=%d, static_rate = %d, port_num=%d\n",
 		   attr->grh.dgid.global.interface_id,
 		   attr->grh.dgid.global.subnet_prefix,
@@ -574,7 +576,7 @@ static void qelr_print_ah_attr(struct qelr_devctx *cxt, struct ibv_ah_attr *attr
 
 static void qelr_print_qp_attr(struct qelr_devctx *cxt, struct ibv_qp_attr *attr)
 {
-	DP_VERBOSE(cxt->dbg_fp, QELR_MSG_QP,
+	LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_QP, VERBS_DBG_LEVEL_VERBOSE,
 		   "\tqp_state=%d\tcur_qp_state=%d\tpath_mtu=%d\tpath_mig_state=%d\tqkey=%d\trq_psn=%d\tsq_psn=%d\tdest_qp_num=%d\tqp_access_flags=%d\tmax_inline_data=%d\tmax_recv_sge=%d\tmax_recv_wr=%d\tmax_send_sge=%d\tmax_send_wr=%d\tpkey_index=%d\talt_pkey_index=%d\ten_sqd_async_notify=%d\tsq_draining=%d\tmax_rd_atomic=%d\tmax_dest_rd_atomic=%d\tmin_rnr_timer=%d\tport_num=%d\ttimeout=%d\tretry_cnt=%d\trnr_retry=%d\talt_port_num=%d\talt_timeout=%d\n",
 		   attr->qp_state, attr->cur_qp_state, attr->path_mtu,
 		   attr->path_mig_state, attr->qkey, attr->rq_psn, attr->sq_psn,
@@ -599,8 +601,8 @@ int qelr_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 	struct qelr_devctx *cxt = get_qelr_ctx(qp->context);
 	int rc;
 
-	DP_VERBOSE(cxt->dbg_fp, QELR_MSG_QP, "QP Query %p, attr_mask=0x%x\n",
-		   get_qelr_qp(qp), attr_mask);
+	LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_QP, VERBS_DBG_LEVEL_VERBOSE,
+			"QP Query %p, attr_mask=0x%x\n", get_qelr_qp(qp), attr_mask);
 
 	rc = ibv_cmd_query_qp(qp, attr, attr_mask,
 			      init_attr, &cmd, sizeof(cmd));
@@ -768,16 +770,16 @@ int qelr_modify_qp(struct ibv_qp *ibqp, struct ibv_qp_attr *attr,
 	struct qelr_devctx *cxt = get_qelr_ctx(ibqp->context);
 	int rc;
 
-	DP_VERBOSE(cxt->dbg_fp, QELR_MSG_QP, "QP Modify %p, attr_mask=0x%x\n",
-		   qp, attr_mask);
+	LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_QP, VERBS_DBG_LEVEL_VERBOSE,
+			"QP Modify %p, attr_mask=0x%x\n", qp, attr_mask);
 
 	qelr_print_qp_attr(cxt, attr);
 
 	rc = ibv_cmd_modify_qp(ibqp, attr, attr_mask, &cmd, sizeof(cmd));
 
 	if (!rc && (attr_mask & IBV_QP_STATE)) {
-		DP_VERBOSE(cxt->dbg_fp, QELR_MSG_QP, "QP Modify state %d->%d\n",
-			   qp->state, attr->qp_state);
+		LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_QP, VERBS_DBG_LEVEL_VERBOSE,
+				"QP Modify state %d->%d\n", qp->state, attr->qp_state);
 		qelr_update_qp_state(qp, attr->qp_state);
 	}
 
@@ -790,11 +792,12 @@ int qelr_destroy_qp(struct ibv_qp *ibqp)
 	struct qelr_qp *qp = get_qelr_qp(ibqp);
 	int rc = 0;
 
-	DP_VERBOSE(cxt->dbg_fp, QELR_MSG_QP, "destroy qp: %p\n", qp);
+	LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_QP, VERBS_DBG_LEVEL_VERBOSE,
+			"destroy qp: %p\n", qp);
 
 	rc = ibv_cmd_destroy_qp(ibqp);
 	if (rc) {
-		DP_ERR(cxt->dbg_fp,
+		LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
 		       "destroy qp: failed to destroy %p, got %d.\n", qp, rc);
 		return rc;
 	}
@@ -805,7 +808,7 @@ int qelr_destroy_qp(struct ibv_qp *ibqp)
 	qelr_chain_free_rq(qp);
 	free(qp);
 
-	DP_VERBOSE(cxt->dbg_fp, QELR_MSG_QP,
+	LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_QP, VERBS_DBG_LEVEL_VERBOSE,
 		   "destroy cq: succesfully destroyed %p\n", qp);
 
 	return 0;
@@ -933,7 +936,8 @@ static uint32_t qelr_prepare_sq_inline_data(struct qelr_qp *qp,
 	uint32_t data_size = sge_data_len(wr->sg_list, wr->num_sge);
 
 	if (data_size > ROCE_REQ_MAX_INLINE_DATA_SIZE) {
-		DP_ERR(stderr, "Too much inline data in WR: %d\n", data_size);
+		PRINT_DBG(VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
+				"Too much inline data in WR: %d\n", data_size);
 		*bad_wr = wr;
 		return 0;
 	}
@@ -1208,7 +1212,7 @@ int qelr_post_send(struct ibv_qp *ib_qp, struct ibv_send_wr *wr,
 			qp->wqe_wr_id[qp->sq.prod].wqe_size = swqe->wqe_size;
 			qp->prev_wqe_size = swqe->wqe_size;
 			qp->wqe_wr_id[qp->sq.prod].bytes_len = swqe->length;
-			FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
+			LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_CQ, VERBS_DBG_LEVEL_VERBOSE,
 				      "SEND w/ IMM length = %d imm data=%x\n",
 				      swqe->length, wr->imm_data);
 			break;
@@ -1230,7 +1234,7 @@ int qelr_post_send(struct ibv_qp *ib_qp, struct ibv_send_wr *wr,
 			qp->wqe_wr_id[qp->sq.prod].wqe_size = swqe->wqe_size;
 			qp->prev_wqe_size = swqe->wqe_size;
 			qp->wqe_wr_id[qp->sq.prod].bytes_len = swqe->length;
-			FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
+			LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_CQ, VERBS_DBG_LEVEL_VERBOSE,
 				      "SEND w/o IMM length = %d\n",
 				      swqe->length);
 			break;
@@ -1257,7 +1261,7 @@ int qelr_post_send(struct ibv_qp *ib_qp, struct ibv_send_wr *wr,
 			qp->wqe_wr_id[qp->sq.prod].wqe_size = rwqe->wqe_size;
 			qp->prev_wqe_size = rwqe->wqe_size;
 			qp->wqe_wr_id[qp->sq.prod].bytes_len = rwqe->length;
-			FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
+			LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_CQ, VERBS_DBG_LEVEL_VERBOSE,
 				      "RDMA WRITE w/ IMM length = %d imm data=%x\n",
 				      rwqe->length, rwqe->imm_data);
 			break;
@@ -1281,7 +1285,7 @@ int qelr_post_send(struct ibv_qp *ib_qp, struct ibv_send_wr *wr,
 			qp->wqe_wr_id[qp->sq.prod].wqe_size = rwqe->wqe_size;
 			qp->prev_wqe_size = rwqe->wqe_size;
 			qp->wqe_wr_id[qp->sq.prod].bytes_len = rwqe->length;
-			FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
+			LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_CQ, VERBS_DBG_LEVEL_VERBOSE,
 				      "RDMA WRITE w/o IMM length = %d\n",
 				      rwqe->length);
 			break;
@@ -1301,15 +1305,16 @@ int qelr_post_send(struct ibv_qp *ib_qp, struct ibv_send_wr *wr,
 			qp->wqe_wr_id[qp->sq.prod].wqe_size = rwqe->wqe_size;
 			qp->prev_wqe_size = rwqe->wqe_size;
 			qp->wqe_wr_id[qp->sq.prod].bytes_len = rwqe->length;
-			FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
+			LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_CQ, VERBS_DBG_LEVEL_VERBOSE,
 				      "RDMA READ length = %d\n", rwqe->length);
 			break;
 
 		case IBV_WR_ATOMIC_CMP_AND_SWP:
 		case IBV_WR_ATOMIC_FETCH_AND_ADD:
-			FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ, "ATOMIC\n");
+			LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_CQ, VERBS_DBG_LEVEL_VERBOSE,
+					"ATOMIC\n");
 			if (!qp->atomic_supported) {
-				DP_ERR(cxt->dbg_fp,
+				LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
 				       "Atomic not supported on this machine\n");
 				status = -EINVAL;
 				*bad_wr = wr;
@@ -1362,7 +1367,8 @@ int qelr_post_send(struct ibv_qp *ib_qp, struct ibv_send_wr *wr,
 			/* restore prev_wqe_size */
 			qp->prev_wqe_size = wqe->prev_wqe_size;
 			status = -EINVAL;
-			DP_ERR(cxt->dbg_fp, "POST SEND FAILED\n");
+			LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
+					"POST SEND FAILED\n");
 			break; /* out of the loop */
 		}
 
@@ -1413,7 +1419,7 @@ int qelr_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 
 		if (qelr_chain_get_elem_left_u32(&qp->rq.chain) <
 		    QELR_MAX_RQ_WQE_SIZE || wr->num_sge > qp->rq.max_sges) {
-			DP_ERR(cxt->dbg_fp,
+			LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
 			       "Can't post WR  (%d < %d) || (%d > %d)\n",
 			       qelr_chain_get_elem_left_u32(&qp->rq.chain),
 			       QELR_MAX_RQ_WQE_SIZE, wr->num_sge,
@@ -1422,7 +1428,7 @@ int qelr_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 			*bad_wr = wr;
 			break;
 		}
-		FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
+		LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_CQ, VERBS_DBG_LEVEL_VERBOSE,
 			      "RQ WR: SGEs: %d with wr_id[%d] = %lx\n",
 			      wr->num_sge, qp->rq.prod, wr->wr_id);
 		for (i = 0; i < wr->num_sge; i++) {
@@ -1441,7 +1447,7 @@ int qelr_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 			rqe = qelr_chain_produce(&qp->rq.chain);
 			RQ_SGE_SET(rqe, wr->sg_list[i].addr,
 				   wr->sg_list[i].length, flags);
-			FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
+			LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_CQ, VERBS_DBG_LEVEL_VERBOSE,
 				      "[%d]: len %d key %x addr %x:%x\n", i,
 				      rqe->length, rqe->flags,
 				      rqe->addr.hi, rqe->addr.lo);
@@ -1482,8 +1488,9 @@ int qelr_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 		wr = wr->next;
 	}
 
-	FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ, "POST: Elements in RespQ: %d\n",
-		      qelr_chain_get_elem_left_u32(&qp->rq.chain));
+	LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_CQ, VERBS_DBG_LEVEL_VERBOSE,
+			"POST: Elements in RespQ: %d\n",
+			qelr_chain_get_elem_left_u32(&qp->rq.chain));
 	pthread_spin_unlock(&qp->q_lock);
 
 	return status;
@@ -1536,7 +1543,7 @@ static int process_req(struct qelr_qp *qp, struct qelr_cq *cq, int num_entries,
 		switch (wc->opcode) {
 		case IBV_WC_RDMA_WRITE:
 			wc->byte_len = qp->wqe_wr_id[qp->sq.cons].bytes_len;
-			DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
+			LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_CQ, VERBS_DBG_LEVEL_VERBOSE,
 				   "POLL REQ CQ: IBV_WC_RDMA_WRITE byte_len=%d\n",
 				   qp->wqe_wr_id[qp->sq.cons].bytes_len);
 			break;
@@ -1547,7 +1554,7 @@ static int process_req(struct qelr_qp *qp, struct qelr_cq *cq, int num_entries,
 		case IBV_WC_RDMA_READ:
 		case IBV_WC_SEND:
 		case IBV_WC_BIND_MW:
-			DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
+			LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_CQ, VERBS_DBG_LEVEL_VERBOSE,
 				   "POLL REQ CQ: IBV_WC_RDMA_READ / IBV_WC_SEND\n");
 			break;
 		default:
@@ -1579,7 +1586,8 @@ static int qelr_poll_cq_req(struct qelr_qp *qp, struct qelr_cq *cq,
 				  IBV_WC_SUCCESS, 0);
 		break;
 	case RDMA_CQE_REQ_STS_WORK_REQUEST_FLUSHED_ERR:
-		DP_ERR(cxt->dbg_fp,
+
+		LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
 		       "Error: POLL CQ with ROCE_CQE_REQ_STS_WORK_REQUEST_FLUSHED_ERR. QP icid=0x%x\n",
 		       qp->sq.icid);
 		cnt = process_req(qp, cq, num_entries, wc, req->sq_cons,
@@ -1597,67 +1605,78 @@ static int qelr_poll_cq_req(struct qelr_qp *qp, struct qelr_cq *cq,
 
 			switch (req->status) {
 			case	RDMA_CQE_REQ_STS_BAD_RESPONSE_ERR:
-				DP_ERR(cxt->dbg_fp,
+
+				LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
 				       "Error: POLL CQ with RDMA_CQE_REQ_STS_BAD_RESPONSE_ERR. QP icid=0x%x\n",
 				       qp->sq.icid);
 				wc_status = IBV_WC_BAD_RESP_ERR;
 				break;
 			case	RDMA_CQE_REQ_STS_LOCAL_LENGTH_ERR:
-				DP_ERR(cxt->dbg_fp,
+
+				LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
 				       "Error: POLL CQ with RDMA_CQE_REQ_STS_LOCAL_LENGTH_ERR. QP icid=0x%x\n",
 				       qp->sq.icid);
 				wc_status = IBV_WC_LOC_LEN_ERR;
 				break;
 			case    RDMA_CQE_REQ_STS_LOCAL_QP_OPERATION_ERR:
-				DP_ERR(cxt->dbg_fp,
+
+				LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
 				       "Error: POLL CQ with RDMA_CQE_REQ_STS_LOCAL_QP_OPERATION_ERR. QP icid=0x%x\n",
 				       qp->sq.icid);
 				wc_status = IBV_WC_LOC_QP_OP_ERR;
 				break;
 			case    RDMA_CQE_REQ_STS_LOCAL_PROTECTION_ERR:
-				DP_ERR(cxt->dbg_fp,
+
+				LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
 				       "Error: POLL CQ with RDMA_CQE_REQ_STS_LOCAL_PROTECTION_ERR. QP icid=0x%x\n",
 				       qp->sq.icid);
 				wc_status = IBV_WC_LOC_PROT_ERR;
 				break;
 			case    RDMA_CQE_REQ_STS_MEMORY_MGT_OPERATION_ERR:
-				DP_ERR(cxt->dbg_fp,
+
+				LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
 				       "Error: POLL CQ with RDMA_CQE_REQ_STS_MEMORY_MGT_OPERATION_ERR. QP icid=0x%x\n",
 				       qp->sq.icid);
 				wc_status = IBV_WC_MW_BIND_ERR;
 				break;
 			case    RDMA_CQE_REQ_STS_REMOTE_INVALID_REQUEST_ERR:
-				DP_ERR(cxt->dbg_fp,
+
+				LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
 				       "Error: POLL CQ with RDMA_CQE_REQ_STS_REMOTE_INVALID_REQUEST_ERR. QP icid=0x%x\n",
 				       qp->sq.icid);
 				wc_status = IBV_WC_REM_INV_REQ_ERR;
 				break;
 			case    RDMA_CQE_REQ_STS_REMOTE_ACCESS_ERR:
-				DP_ERR(cxt->dbg_fp,
+
+				LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
 				       "Error: POLL CQ with RDMA_CQE_REQ_STS_REMOTE_ACCESS_ERR. QP icid=0x%x\n",
 				       qp->sq.icid);
 				wc_status = IBV_WC_REM_ACCESS_ERR;
 				break;
 			case    RDMA_CQE_REQ_STS_REMOTE_OPERATION_ERR:
-				DP_ERR(cxt->dbg_fp,
+
+				LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
 				       "Error: POLL CQ with RDMA_CQE_REQ_STS_REMOTE_OPERATION_ERR. QP icid=0x%x\n",
 				       qp->sq.icid);
 				wc_status = IBV_WC_REM_OP_ERR;
 				break;
 			case    RDMA_CQE_REQ_STS_RNR_NAK_RETRY_CNT_ERR:
-				DP_ERR(cxt->dbg_fp,
+
+				LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
 				       "Error: POLL CQ with RDMA_CQE_REQ_STS_RNR_NAK_RETRY_CNT_ERR. QP icid=0x%x\n",
 				       qp->sq.icid);
 				wc_status = IBV_WC_RNR_RETRY_EXC_ERR;
 				break;
 			case    RDMA_CQE_REQ_STS_TRANSPORT_RETRY_CNT_ERR:
-				DP_ERR(cxt->dbg_fp,
+
+				LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
 				       "RDMA_CQE_REQ_STS_TRANSPORT_RETRY_CNT_ERR. QP icid=0x%x\n",
 				       qp->sq.icid);
 				wc_status = IBV_WC_RETRY_EXC_ERR;
 				break;
 			default:
-				DP_ERR(cxt->dbg_fp,
+
+				LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
 				       "IBV_WC_GENERAL_ERR. QP icid=0x%x\n",
 					qp->sq.icid);
 				wc_status = IBV_WC_GENERAL_ERR;
@@ -1682,7 +1701,7 @@ static void __process_resp_one(struct qelr_qp *qp, struct qelr_cq *cq,
 	wc->opcode = IBV_WC_RECV;
 	wc->wc_flags = 0;
 
-	FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ, "\n");
+	LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_CQ, VERBS_DBG_LEVEL_VERBOSE, "\n");
 
 	switch (resp->status) {
 	case RDMA_CQE_RESP_STS_LOCAL_ACCESS_ERR:
@@ -1718,12 +1737,14 @@ static void __process_resp_one(struct qelr_qp *qp, struct qelr_cq *cq,
 			wc->imm_data =
 				ntohl(le32toh(resp->imm_data_or_inv_r_Key));
 			wc->wc_flags |= IBV_WC_WITH_IMM;
-			FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
+			LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_CQ, VERBS_DBG_LEVEL_VERBOSE,
 				      "POLL CQ RQ2: RESP_RDMA_IMM imm_data = %x resp_len=%d\n",
 				      wc->imm_data, wc->byte_len);
 			break;
 		case QELR_RESP_RDMA:
-			DP_ERR(cxt->dbg_fp, "Invalid flags detected\n");
+
+			LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
+					"Invalid flags detected\n");
 			break;
 		default:
 			/* valid configuration, but nothing to do here */
@@ -1734,7 +1755,8 @@ static void __process_resp_one(struct qelr_qp *qp, struct qelr_cq *cq,
 		break;
 	default:
 		wc->status = IBV_WC_GENERAL_ERR;
-		DP_ERR(cxt->dbg_fp, "Invalid CQE status detected\n");
+		LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
+				"Invalid CQE status detected\n");
 	}
 
 	/* fill WC */
@@ -1851,8 +1873,7 @@ int qelr_poll_cq(struct ibv_cq *ibcq, int num_entries, struct ibv_wc *wc)
 
 		qp = cqe_get_qp(cqe);
 		if (!qp) {
-			DP_ERR(stderr,
-			       "Error: CQE QP pointer is NULL. CQE=%p\n", cqe);
+			PRINT_ERR("Error: CQE QP pointer is NULL. CQE=%p\n", cqe);
 			break;
 		}
 
@@ -1884,8 +1905,8 @@ int qelr_poll_cq(struct ibv_cq *ibcq, int num_entries, struct ibv_wc *wc)
 		 * but chain already point to the next INVALID one
 		 */
 		doorbell_cq(cq, db_cons, cq->arm_flags);
-		FP_DP_VERBOSE(stderr, QELR_MSG_CQ, "doorbell_cq cons=%x\n",
-			      db_cons);
+		PRINT_DBG(VERBS_DBG_MASK_CQ, VERBS_DBG_LEVEL_VERBOSE,
+				"doorbell_cq cons=%x\n", db_cons);
 	}
 
 	return done;
@@ -1905,8 +1926,9 @@ int qelr_arm_cq(struct ibv_cq *ibcq, int solicited)
 	uint32_t db_cons;
 
 	db_cons = qelr_chain_get_cons_idx_u32(&cq->chain) - 1;
-	FP_DP_VERBOSE(get_qelr_ctx(ibcq->context)->dbg_fp, QELR_MSG_CQ,
-		      "Arm CQ cons=%x solicited=%d\n", db_cons, solicited);
+	LOG_DBG_FLUSH(get_qelr_ctx(ibcq->context)->dbg_fp,
+			VERBS_DBG_MASK_CQ, VERBS_DBG_LEVEL_VERBOSE,
+			"Arm CQ cons=%x solicited=%d\n", db_cons, solicited);
 
 	cq->arm_flags = solicited ? DQ_UCM_ROCE_CQ_ARM_SE_CF_CMD :
 				    DQ_UCM_ROCE_CQ_ARM_CF_CMD;
-- 
1.8.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
