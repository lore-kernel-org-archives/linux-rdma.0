From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-core] i40iw: Set 128B as the only supported RQ WQE size
Date: Mon, 19 Dec 2016 14:31:17 -0600
Message-ID: <1482179477-100780-1-git-send-email-tatyana.e.nikolova@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

RQ WQE size other than 128B is not supported.
Correct RQ size calculation to use 128B only.

Since this breaks ABI, add code to provide
compatibility with V4 kernel driver, i40iw.

Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 providers/i40iw/i40iw-abi.h    |  3 +--
 providers/i40iw/i40iw_uk.c     | 18 +++++++++++++-----
 providers/i40iw/i40iw_umain.c  | 15 +++++++++++----
 providers/i40iw/i40iw_umain.h  |  1 +
 providers/i40iw/i40iw_user.h   |  4 +++-
 providers/i40iw/i40iw_uverbs.c | 20 +++++++++++++++-----
 6 files changed, 44 insertions(+), 17 deletions(-)

diff --git a/providers/i40iw/i40iw-abi.h b/providers/i40iw/i40iw-abi.h
index 88c8c72..df2df07 100644
--- a/providers/i40iw/i40iw-abi.h
+++ b/providers/i40iw/i40iw-abi.h
@@ -37,8 +37,7 @@
 
 #include <infiniband/kern-abi.h>
 
-#define I40IW_ABI_USERSPACE_VER 4
-#define I40IW_ABI_KERNEL_VER 4
+#define I40IW_ABI_VER 5
 
 struct i40iw_get_context {
 	struct ibv_get_context cmd;
diff --git a/providers/i40iw/i40iw_uk.c b/providers/i40iw/i40iw_uk.c
index 392e858..ea3255f 100644
--- a/providers/i40iw/i40iw_uk.c
+++ b/providers/i40iw/i40iw_uk.c
@@ -970,11 +970,8 @@ enum i40iw_status_code i40iw_qp_uk_init(struct i40iw_qp_uk *qp,
 
 	if (info->max_rq_frag_cnt > I40IW_MAX_WQ_FRAGMENT_COUNT)
 		return I40IW_ERR_INVALID_FRAG_COUNT;
-	ret_code = i40iw_get_wqe_shift(info->sq_size, info->max_sq_frag_cnt, info->max_inline_data, &sqshift);
-	if (ret_code)
-		return ret_code;
 
-	ret_code = i40iw_get_wqe_shift(info->rq_size, info->max_rq_frag_cnt, 0, &rqshift);
+	ret_code = i40iw_get_wqe_shift(info->sq_size, info->max_sq_frag_cnt, info->max_inline_data, &sqshift);
 	if (ret_code)
 		return ret_code;
 
@@ -1006,8 +1003,19 @@ enum i40iw_status_code i40iw_qp_uk_init(struct i40iw_qp_uk *qp,
 	if (!qp->use_srq) {
 		qp->rq_size = info->rq_size;
 		qp->max_rq_frag_cnt = info->max_rq_frag_cnt;
-		qp->rq_wqe_size = rqshift;
 		I40IW_RING_INIT(qp->rq_ring, qp->rq_size);
+		switch (info->abi_ver) {
+		case 4:
+			ret_code = i40iw_get_wqe_shift(info->rq_size, info->max_rq_frag_cnt, 0, &rqshift);
+			if (ret_code)
+				return ret_code;
+			break;
+		case 5: /* fallthrough until next ABI version */
+		default:
+			rqshift = I40IW_MAX_RQ_WQE_SHIFT;
+			break;
+		}
+		qp->rq_wqe_size = rqshift;
 		qp->rq_wqe_size_multiplier = 4 << rqshift;
 	}
 	qp->ops = iw_qp_uk_ops;
diff --git a/providers/i40iw/i40iw_umain.c b/providers/i40iw/i40iw_umain.c
index 8d7b655..a1e98ac 100644
--- a/providers/i40iw/i40iw_umain.c
+++ b/providers/i40iw/i40iw_umain.c
@@ -154,15 +154,21 @@ static struct ibv_context *i40iw_ualloc_context(struct ibv_device *ibdev, int cm
 
 	memset(iwvctx, 0, sizeof(*iwvctx));
 	iwvctx->ibv_ctx.cmd_fd = cmd_fd;
-	cmd.userspace_ver = I40IW_ABI_USERSPACE_VER;
+	cmd.userspace_ver = I40IW_ABI_VER;
 	memset(&resp, 0, sizeof(resp));
 	if (ibv_cmd_get_context(&iwvctx->ibv_ctx, (struct ibv_get_context *)&cmd,
+				sizeof(cmd), &resp.ibv_resp, sizeof(resp))) {
+
+		cmd.userspace_ver = 4;
+		if (ibv_cmd_get_context(&iwvctx->ibv_ctx, (struct ibv_get_context *)&cmd,
 				sizeof(cmd), &resp.ibv_resp, sizeof(resp)))
-		goto err_free;
+			goto err_free;
+
+	}
 
-	if (resp.kernel_ver != I40IW_ABI_KERNEL_VER) {
+	if (resp.kernel_ver > I40IW_ABI_VER) {
 		fprintf(stderr, PFX "%s: incompatible kernel driver version: %d.  Need version %d\n",
-			__func__, resp.kernel_ver, I40IW_ABI_KERNEL_VER);
+			__func__, resp.kernel_ver, I40IW_ABI_VER);
 		goto err_free;
 	}
 
@@ -171,6 +177,7 @@ static struct ibv_context *i40iw_ualloc_context(struct ibv_device *ibdev, int cm
 	iwvctx->max_pds = resp.max_pds;
 	iwvctx->max_qps = resp.max_qps;
 	iwvctx->wq_size = resp.wq_size;
+	iwvctx->abi_ver = resp.kernel_ver;
 
 	i40iw_device_init_uk(&iwvctx->dev);
 	ibv_pd = i40iw_ualloc_pd(&iwvctx->ibv_ctx);
diff --git a/providers/i40iw/i40iw_umain.h b/providers/i40iw/i40iw_umain.h
index 719aefc..06d38a2 100644
--- a/providers/i40iw/i40iw_umain.h
+++ b/providers/i40iw/i40iw_umain.h
@@ -95,6 +95,7 @@ struct i40iw_uvcontext {
 	uint32_t max_qps;	/* maximum qps allowed for this user process */
 	uint32_t wq_size;	/* size of the WQs (sq+rq) + shadow allocated to the mmaped area */
 	struct i40iw_dev_uk dev;
+	int abi_ver;
 };
 
 struct i40iw_uqp;
diff --git a/providers/i40iw/i40iw_user.h b/providers/i40iw/i40iw_user.h
index 8d345b3..1e95c23 100644
--- a/providers/i40iw/i40iw_user.h
+++ b/providers/i40iw/i40iw_user.h
@@ -77,6 +77,7 @@ enum i40iw_device_capabilities_const {
 	I40IW_MAX_WQ_ENTRIES =			2048,
 	I40IW_MAX_ORD_SIZE =			32,
 	I40IW_Q2_BUFFER_SIZE =			(248 + 100),
+	I40IW_MAX_WQE_SIZE_RQ =			128,
 	I40IW_QP_CTX_SIZE =			248
 };
 
@@ -103,6 +104,7 @@ enum i40iw_device_capabilities_const {
 #define I40IW_STAG_INDEX_FROM_STAG(stag)    (((stag) && 0xFFFFFF00) >> 8)
 
 #define	I40IW_MAX_MR_SIZE	0x10000000000L
+#define I40IW_MAX_RQ_WQE_SHIFT	2
 
 struct i40iw_qp_uk;
 struct i40iw_cq_uk;
@@ -411,7 +413,7 @@ struct i40iw_qp_uk_init_info {
 	u32 max_sq_frag_cnt;
 	u32 max_rq_frag_cnt;
 	u32 max_inline_data;
-
+	int abi_ver;
 };
 
 struct i40iw_cq_uk_init_info {
diff --git a/providers/i40iw/i40iw_uverbs.c b/providers/i40iw/i40iw_uverbs.c
index 4a868ea..a946fcc 100644
--- a/providers/i40iw/i40iw_uverbs.c
+++ b/providers/i40iw/i40iw_uverbs.c
@@ -661,12 +661,21 @@ struct ibv_qp *i40iw_ucreate_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr
 		return NULL;
 	}
 
-	rqdepth = i40iw_qp_get_qdepth(rq_attr, attr->cap.max_recv_sge, 0);
-	if (!rqdepth) {
-		fprintf(stderr, PFX "%s: invalid RQ attributes, max_recv_wr=%d max_recv_sge=%d\n",
-			__func__, attr->cap.max_recv_wr, attr->cap.max_recv_sge);
-		return NULL;
+	switch (iwvctx->abi_ver) {
+	case 4:
+		rqdepth = i40iw_qp_get_qdepth(rq_attr, attr->cap.max_recv_sge, 0);
+		if (!rqdepth) {
+			fprintf(stderr, PFX "%s: invalid RQ attributes, max_recv_wr=%d max_recv_sge=%d\n",
+				__func__, attr->cap.max_recv_wr, attr->cap.max_recv_sge);
+			return NULL;
+		}
+		break;
+	case 5: /* fallthrough until next ABI version */
+	default:
+		rqdepth = rq_attr << I40IW_MAX_RQ_WQE_SHIFT;
+		break;
 	}
+
 	iwuqp = memalign(1024, sizeof(*iwuqp));
 	if (!iwuqp)
 		return NULL;
@@ -687,6 +696,7 @@ struct ibv_qp *i40iw_ucreate_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr
 
 	info.wqe_alloc_reg = (u32 *)iwvctx->iwupd->db;
 	info.sq_wrtrk_array = calloc(sqdepth, sizeof(*info.sq_wrtrk_array));
+	info.abi_ver = iwvctx->abi_ver;
 
 	if (!info.sq_wrtrk_array) {
 		fprintf(stderr, PFX "%s: failed to allocate memory for SQ work array\n", __func__);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
