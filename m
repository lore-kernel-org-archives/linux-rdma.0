From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-core] providers/i40iw: Refactor queue depth calculation
Date: Wed, 18 Oct 2017 16:15:42 -0500
Message-ID: <20171018211542.13056-1-tatyana.e.nikolova@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Queue depth calculations use a mix of work requests
and actual number of bytes.  Consolidate all calculations
using minimum WQE size to avoid confusion.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 providers/i40iw/i40iw_d.h      |  8 +++--
 providers/i40iw/i40iw_uk.c     | 64 +++++++++++++++++++++++++--------
 providers/i40iw/i40iw_user.h   |  4 ++-
 providers/i40iw/i40iw_uverbs.c | 81 +++++++++++-------------------------------
 4 files changed, 77 insertions(+), 80 deletions(-)

diff --git a/providers/i40iw/i40iw_d.h b/providers/i40iw/i40iw_d.h
index 174115c3..4652dcb2 100644
--- a/providers/i40iw/i40iw_d.h
+++ b/providers/i40iw/i40iw_d.h
@@ -1315,9 +1315,11 @@
 #define I40IWQPC_LOCAL_IPADDR0_MASK     \
 	(0xffffffffULL << I40IWQPC_LOCAL_IPADDR0_SHIFT)
 
-/* wqe size considering 32 bytes per wqe*/
-#define I40IWQP_SW_MIN_WQSIZE 4		/* 128 bytes */
-#define I40IWQP_SW_MAX_WQSIZE 2048	/* 2048 bytes */
+#define I40IW_QP_SW_MIN_WQSIZE 4		/*in WRs*/
+#define I40IW_SQ_RSVD 2
+#define I40IW_RQ_RSVD 1
+#define I40IW_QP_SW_MAX_SQ_QUANTAS 2048
+#define I40IW_QP_SW_MAX_RQ_QUANTAS 16384
 #define I40IWQP_OP_RDMA_WRITE 0
 #define I40IWQP_OP_RDMA_READ 1
 #define I40IWQP_OP_RDMA_SEND 3
diff --git a/providers/i40iw/i40iw_uk.c b/providers/i40iw/i40iw_uk.c
index 05d919ca..624b3301 100644
--- a/providers/i40iw/i40iw_uk.c
+++ b/providers/i40iw/i40iw_uk.c
@@ -912,9 +912,22 @@ exit:
 	return ret_code;
 }
 
+/**
+ * i40iw_qp_roundup - return round up QP WQ depth
+ * @wqdepth: WQ depth in quantas to round up
+ */
+static int i40iw_qp_round_up(u32 wqdepth)
+{
+	int scount = 1;
+
+	for (wqdepth--; scount <= 16; scount *= 2)
+		wqdepth |= wqdepth >> scount;
+
+	return ++wqdepth;
+}
+
 /**
  * i40iw_get_wqe_shift - get shift count for maximum wqe size
- * @wqdepth: depth of wq required.
  * @sge: Maximum Scatter Gather Elements wqe
  * @inline_data: Maximum inline data size
  * @shift: Returns the shift needed based on sge
@@ -924,22 +937,48 @@ exit:
  * For 2 or 3 SGEs or inline data <= 48, shift = 1 (wqe size of 64 bytes).
  * Shift of 2 otherwise (wqe size of 128 bytes).
  */
-enum i40iw_status_code i40iw_get_wqe_shift(u32 wqdepth, u32 sge, u32 inline_data, u8 *shift)
+void i40iw_get_wqe_shift(u32 sge, u32 inline_data, u8 *shift)
 {
-	u32 size;
-
 	*shift = 0;
 	if (sge > 1 || inline_data > 16)
 		*shift = (sge < 4 && inline_data <= 48) ? 1 : 2;
+}
 
-	/* check if wqdepth is multiple of 2 or not */
+/*
+ * i40iw_get_sqdepth - get SQ depth (quantas)
+ * @sq_size: SQ size
+ * @shift: shift which determines size of WQE
+ * @sqdepth: depth of SQ
+ *
+ */
+enum i40iw_status_code i40iw_get_sqdepth(u32 sq_size, u8 shift, u32 *sqdepth)
+{
+	*sqdepth = i40iw_qp_round_up((sq_size << shift) + I40IW_SQ_RSVD);
 
-	if ((wqdepth < I40IWQP_SW_MIN_WQSIZE) || (wqdepth & (wqdepth - 1)))
+	if (*sqdepth < (I40IW_QP_SW_MIN_WQSIZE << shift))
+		*sqdepth = I40IW_QP_SW_MIN_WQSIZE << shift;
+	else if (*sqdepth > I40IW_QP_SW_MAX_SQ_QUANTAS)
 		return I40IW_ERR_INVALID_SIZE;
 
-	size = wqdepth << *shift;	/* multiple of 32 bytes count */
-	if (size > I40IWQP_SW_MAX_WQSIZE)
+	return 0;
+}
+
+/*
+ * i40iw_get_rq_depth - get RQ depth (quantas)
+ * @rq_size: RQ size
+ * @shift: shift which determines size of WQE
+ * @rqdepth: depth of RQ
+ *
+ */
+enum i40iw_status_code i40iw_get_rqdepth(u32 rq_size, u8 shift, u32 *rqdepth)
+{
+	*rqdepth = i40iw_qp_round_up((rq_size << shift) + I40IW_RQ_RSVD);
+
+	if (*rqdepth < (I40IW_QP_SW_MIN_WQSIZE << shift))
+		*rqdepth = I40IW_QP_SW_MIN_WQSIZE << shift;
+	else if (*rqdepth > I40IW_QP_SW_MAX_RQ_QUANTAS)
 		return I40IW_ERR_INVALID_SIZE;
+
 	return 0;
 }
 
@@ -993,10 +1032,7 @@ enum i40iw_status_code i40iw_qp_uk_init(struct i40iw_qp_uk *qp,
 
 	if (info->max_rq_frag_cnt > I40IW_MAX_WQ_FRAGMENT_COUNT)
 		return I40IW_ERR_INVALID_FRAG_COUNT;
-
-	ret_code = i40iw_get_wqe_shift(info->sq_size, info->max_sq_frag_cnt, info->max_inline_data, &sqshift);
-	if (ret_code)
-		return ret_code;
+	i40iw_get_wqe_shift(info->max_sq_frag_cnt, info->max_inline_data, &sqshift);
 
 	qp->sq_base = info->sq;
 	qp->rq_base = info->rq;
@@ -1030,9 +1066,7 @@ enum i40iw_status_code i40iw_qp_uk_init(struct i40iw_qp_uk *qp,
 		I40IW_RING_INIT(qp->rq_ring, qp->rq_size);
 		switch (info->abi_ver) {
 		case 4:
-			ret_code = i40iw_get_wqe_shift(info->rq_size, info->max_rq_frag_cnt, 0, &rqshift);
-			if (ret_code)
-				return ret_code;
+			i40iw_get_wqe_shift(info->max_rq_frag_cnt, 0, &rqshift);
 			break;
 		case 5: /* fallthrough until next ABI version */
 		default:
diff --git a/providers/i40iw/i40iw_user.h b/providers/i40iw/i40iw_user.h
index 7bceca43..921848c1 100644
--- a/providers/i40iw/i40iw_user.h
+++ b/providers/i40iw/i40iw_user.h
@@ -450,5 +450,7 @@ enum i40iw_status_code i40iw_fragcnt_to_wqesize_sq(u32 frag_cnt, u8 *wqe_size);
 enum i40iw_status_code i40iw_fragcnt_to_wqesize_rq(u32 frag_cnt, u8 *wqe_size);
 enum i40iw_status_code i40iw_inline_data_size_to_wqesize(u32 data_size,
 							 u8 *wqe_size);
-enum i40iw_status_code i40iw_get_wqe_shift(u32 wqdepth, u32 sge, u32 inline_data, u8 *shift);
+void i40iw_get_wqe_shift(u32 sge, u32 inline_data, u8 *shift);
+enum i40iw_status_code i40iw_get_sqdepth(u32 sq_size, u8 shift, u32 *sqdepth);
+enum i40iw_status_code i40iw_get_rqdepth(u32 rq_size, u8 shift, u32 *rqdepth);
 #endif
diff --git a/providers/i40iw/i40iw_uverbs.c b/providers/i40iw/i40iw_uverbs.c
index c21d895f..851f1cdf 100644
--- a/providers/i40iw/i40iw_uverbs.c
+++ b/providers/i40iw/i40iw_uverbs.c
@@ -586,40 +586,6 @@ static int i40iw_vmapped_qp(struct i40iw_uqp *iwuqp, struct ibv_pd *pd,
 	return 1;
 }
 
-/**
- * i40iw_qp_round_up - round up rq and sq ring sizes
- * @wr_ring_size: size of the ring
- */
-static int i40iw_qp_round_up(u32 wr_ring_size)
-{
-	int scount = 1;
-
-	if (wr_ring_size <= MIN_WQ_DEPTH)
-		wr_ring_size = MIN_WQ_DEPTH;
-
-	for (wr_ring_size--; scount <= 16; scount *= 2)
-		wr_ring_size |= wr_ring_size >> scount;
-	return ++wr_ring_size;
-}
-
-/*
- * i40iw_qp_get_qdepth of the ring depending of sge and qdepth
- * @qdepth: queue depth
- * @sge: max number of SGEs
- * @inline_data: max QP inline data size
- *
- * returns depth of the ring
- */
-static int i40iw_qp_get_qdepth(uint32_t qdepth, u32 sge, u32 inline_data)
-{
-	u8 shift = 0;
-
-	if (i40iw_get_wqe_shift(qdepth, sge, inline_data, &shift))
-		return 0;
-
-	return (qdepth << shift);
-}
-
 /**
  * i40iw_ucreate_qp - create qp on user app
  * @pd: pd for the qp
@@ -630,10 +596,9 @@ struct ibv_qp *i40iw_ucreate_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr
 	struct i40iw_ucreate_qp_resp resp;
 	struct i40iw_uvcontext *iwvctx = to_i40iw_uctx(pd->context);
 	struct i40iw_uqp *iwuqp;
-	int sqdepth, rqdepth;
-	int status = 1;
 	struct i40iw_qp_uk_init_info info;
-	int sq_attr, rq_attr;
+	u32 sqdepth, rqdepth;
+	u8 sqshift, rqshift;
 
 	if (attr->qp_type != IBV_QPT_RC) {
 		fprintf(stderr, PFX "%s: failed to create QP, unsupported QP type: 0x%x\n", __func__, attr->qp_type);
@@ -649,32 +614,29 @@ struct ibv_qp *i40iw_ucreate_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr
 	if (attr->cap.max_inline_data > I40IW_MAX_INLINE_DATA_SIZE)
 		attr->cap.max_inline_data = I40IW_MAX_INLINE_DATA_SIZE;
 
-	sq_attr = i40iw_qp_round_up(attr->cap.max_send_wr + 1);
-	rq_attr = i40iw_qp_round_up(attr->cap.max_recv_wr + 1);
-
-	/* Sanity check QP size before proceeding */
-	sqdepth = i40iw_qp_get_qdepth(sq_attr, attr->cap.max_send_sge, attr->cap.max_inline_data);
-	if (!sqdepth) {
-		fprintf(stderr, PFX "%s: invalid SQ attributes, max_send_wr=%d max_send_sge=%d\n",
-			__func__, attr->cap.max_send_wr, attr->cap.max_send_sge);
+	i40iw_get_wqe_shift(attr->cap.max_send_sge, attr->cap.max_inline_data, &sqshift);
+	if (i40iw_get_sqdepth(attr->cap.max_send_wr, sqshift, &sqdepth)) {
+		fprintf(stderr, PFX "invalid SQ attributes, max_send_wr=%d max_send_sge=%d max_inline=%d\n",
+			attr->cap.max_send_wr, attr->cap.max_send_sge, attr->cap.max_inline_data);
 		return NULL;
 	}
 
 	switch (iwvctx->abi_ver) {
 	case 4:
-		rqdepth = i40iw_qp_get_qdepth(rq_attr, attr->cap.max_recv_sge, 0);
-		if (!rqdepth) {
-			fprintf(stderr, PFX "%s: invalid RQ attributes, max_recv_wr=%d max_recv_sge=%d\n",
-				__func__, attr->cap.max_recv_wr, attr->cap.max_recv_sge);
-			return NULL;
-		}
+		i40iw_get_wqe_shift(attr->cap.max_recv_sge, 0, &rqshift);
 		break;
 	case 5: /* fallthrough until next ABI version */
 	default:
-		rqdepth = rq_attr << I40IW_MAX_RQ_WQE_SHIFT;
+		rqshift = I40IW_MAX_RQ_WQE_SHIFT;
 		break;
 	}
 
+	if (i40iw_get_rqdepth(attr->cap.max_recv_wr, rqshift, &rqdepth)) {
+		fprintf(stderr, PFX "invalid RQ attributes, max_recv_wr=%d max_recv_sge=%d\n",
+			attr->cap.max_recv_wr, attr->cap.max_recv_sge);
+		return NULL;
+	}
+
 	iwuqp = memalign(1024, sizeof(*iwuqp));
 	if (!iwuqp)
 		return NULL;
@@ -685,10 +647,10 @@ struct ibv_qp *i40iw_ucreate_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr
 
 	memset(&info, 0, sizeof(info));
 
-	info.sq_size = sq_attr;
-	info.rq_size = rq_attr;
-	attr->cap.max_send_wr = sq_attr;
-	attr->cap.max_recv_wr = rq_attr;
+	info.sq_size = sqdepth >> sqshift;
+	info.rq_size = rqdepth >> rqshift;
+	attr->cap.max_send_wr = info.sq_size;
+	attr->cap.max_recv_wr = info.rq_size;
 
 	info.max_sq_frag_cnt = attr->cap.max_send_sge;
 	info.max_rq_frag_cnt = attr->cap.max_recv_sge;
@@ -710,9 +672,7 @@ struct ibv_qp *i40iw_ucreate_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr
 
 	iwuqp->sq_sig_all = attr->sq_sig_all;
 	memset(&resp, 0, sizeof(resp));
-	status = i40iw_vmapped_qp(iwuqp, pd, attr, &resp, sqdepth, rqdepth, &info);
-
-	if (!status) {
+	if (!i40iw_vmapped_qp(iwuqp, pd, attr, &resp, sqdepth, rqdepth, &info)) {
 		fprintf(stderr, PFX "%s: failed to map QP\n", __func__);
 		goto err_free_rq_wrid;
 	}
@@ -724,8 +684,7 @@ struct ibv_qp *i40iw_ucreate_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr
 	info.max_rq_frag_cnt = attr->cap.max_recv_sge;
 	info.max_inline_data = attr->cap.max_inline_data;
 
-	status = iwvctx->dev.ops_uk.iwarp_qp_uk_init(&iwuqp->qp, &info);
-	if (!status)
+	if (!iwvctx->dev.ops_uk.iwarp_qp_uk_init(&iwuqp->qp, &info))
 		return &iwuqp->ibv_qp;
 
 	i40iw_destroy_vmapped_qp(iwuqp, info.sq);
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
