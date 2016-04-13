From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RDMA PATCH 02/16] RDMA/i40iw: Correct QP size calculation
Date: Wed, 13 Apr 2016 09:30:38 -0500
Message-ID: <1460557852-10824-3-git-send-email-mustafa.ismail@intel.com>
References: <1460557852-10824-1-git-send-email-mustafa.ismail@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460557852-10824-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Include inline data size as part of SQ size calculation.
RQ size calculation uses only number of SGEs and does not
support 96 byte WQE size.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_d.h     |  2 +-
 drivers/infiniband/hw/i40iw/i40iw_uk.c    | 80 ++++++++++++-------------------
 drivers/infiniband/hw/i40iw/i40iw_user.h  | 34 +++++++------
 drivers/infiniband/hw/i40iw/i40iw_verbs.c |  8 +++-
 4 files changed, 58 insertions(+), 66 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_d.h b/drivers/infiniband/hw/i40iw/i40iw_d.h
index aab88d6..e8951a7 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_d.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_d.h
@@ -1290,7 +1290,7 @@
 
 /* wqe size considering 32 bytes per wqe*/
 #define I40IWQP_SW_MIN_WQSIZE 4		/* 128 bytes */
-#define I40IWQP_SW_MAX_WQSIZE 16384	/* 524288 bytes */
+#define I40IWQP_SW_MAX_WQSIZE 2048	/* 2048 bytes */
 
 #define I40IWQP_OP_RDMA_WRITE 0
 #define I40IWQP_OP_RDMA_READ 1
diff --git a/drivers/infiniband/hw/i40iw/i40iw_uk.c b/drivers/infiniband/hw/i40iw/i40iw_uk.c
index f78c3dc..9e3a700 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_uk.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_uk.c
@@ -130,7 +130,10 @@ static void i40iw_qp_ring_push_db(struct i40iw_qp_uk *qp, u32 wqe_idx)
  */
 u64 *i40iw_qp_get_next_send_wqe(struct i40iw_qp_uk *qp,
 				u32 *wqe_idx,
-				u8 wqe_size)
+				u8 wqe_size,
+				u32 total_size,
+				u64 wr_id
+				)
 {
 	u64 *wqe = NULL;
 	u64 wqe_ptr;
@@ -171,6 +174,10 @@ u64 *i40iw_qp_get_next_send_wqe(struct i40iw_qp_uk *qp,
 	wqe_0 = qp->sq_base[peek_head].elem;
 	if (peek_head & 0x3)
 		wqe_0[3] = LS_64(!qp->swqe_polarity, I40IWQPSQ_VALID);
+
+	qp->sq_wrtrk_array[*wqe_idx].wrid = wr_id;
+	qp->sq_wrtrk_array[*wqe_idx].wr_len = total_size;
+	qp->sq_wrtrk_array[*wqe_idx].wqe_size = wqe_size;
 	return wqe;
 }
 
@@ -249,12 +256,9 @@ static enum i40iw_status_code i40iw_rdma_write(struct i40iw_qp_uk *qp,
 	if (ret_code)
 		return ret_code;
 
-	wqe = i40iw_qp_get_next_send_wqe(qp, &wqe_idx, wqe_size);
+	wqe = i40iw_qp_get_next_send_wqe(qp, &wqe_idx, wqe_size, total_size, info->wr_id);
 	if (!wqe)
 		return I40IW_ERR_QP_TOOMANY_WRS_POSTED;
-
-	qp->sq_wrtrk_array[wqe_idx].wrid = info->wr_id;
-	qp->sq_wrtrk_array[wqe_idx].wr_len = total_size;
 	set_64bit_val(wqe, 16,
 		      LS_64(op_info->rem_addr.tag_off, I40IWQPSQ_FRAG_TO));
 	if (!op_info->rem_addr.stag)
@@ -309,12 +313,9 @@ static enum i40iw_status_code i40iw_rdma_read(struct i40iw_qp_uk *qp,
 	ret_code = i40iw_fragcnt_to_wqesize_sq(1, &wqe_size);
 	if (ret_code)
 		return ret_code;
-	wqe = i40iw_qp_get_next_send_wqe(qp, &wqe_idx, wqe_size);
+	wqe = i40iw_qp_get_next_send_wqe(qp, &wqe_idx, wqe_size, op_info->lo_addr.len, info->wr_id);
 	if (!wqe)
 		return I40IW_ERR_QP_TOOMANY_WRS_POSTED;
-
-	qp->sq_wrtrk_array[wqe_idx].wrid = info->wr_id;
-	qp->sq_wrtrk_array[wqe_idx].wr_len = op_info->lo_addr.len;
 	local_fence |= info->local_fence;
 
 	set_64bit_val(wqe, 16, LS_64(op_info->rem_addr.tag_off, I40IWQPSQ_FRAG_TO));
@@ -366,13 +367,11 @@ static enum i40iw_status_code i40iw_send(struct i40iw_qp_uk *qp,
 	if (ret_code)
 		return ret_code;
 
-	wqe = i40iw_qp_get_next_send_wqe(qp, &wqe_idx, wqe_size);
+	wqe = i40iw_qp_get_next_send_wqe(qp, &wqe_idx, wqe_size, total_size, info->wr_id);
 	if (!wqe)
 		return I40IW_ERR_QP_TOOMANY_WRS_POSTED;
 
 	read_fence |= info->read_fence;
-	qp->sq_wrtrk_array[wqe_idx].wrid = info->wr_id;
-	qp->sq_wrtrk_array[wqe_idx].wr_len = total_size;
 	set_64bit_val(wqe, 16, 0);
 	header = LS_64(stag_to_inv, I40IWQPSQ_REMSTAG) |
 		 LS_64(info->op_type, I40IWQPSQ_OPCODE) |
@@ -427,13 +426,11 @@ static enum i40iw_status_code i40iw_inline_rdma_write(struct i40iw_qp_uk *qp,
 	if (ret_code)
 		return ret_code;
 
-	wqe = i40iw_qp_get_next_send_wqe(qp, &wqe_idx, wqe_size);
+	wqe = i40iw_qp_get_next_send_wqe(qp, &wqe_idx, wqe_size, op_info->len, info->wr_id);
 	if (!wqe)
 		return I40IW_ERR_QP_TOOMANY_WRS_POSTED;
 
 	read_fence |= info->read_fence;
-	qp->sq_wrtrk_array[wqe_idx].wrid = info->wr_id;
-	qp->sq_wrtrk_array[wqe_idx].wr_len = op_info->len;
 	set_64bit_val(wqe, 16,
 		      LS_64(op_info->rem_addr.tag_off, I40IWQPSQ_FRAG_TO));
 
@@ -507,14 +504,11 @@ static enum i40iw_status_code i40iw_inline_send(struct i40iw_qp_uk *qp,
 	if (ret_code)
 		return ret_code;
 
-	wqe = i40iw_qp_get_next_send_wqe(qp, &wqe_idx, wqe_size);
+	wqe = i40iw_qp_get_next_send_wqe(qp, &wqe_idx, wqe_size, op_info->len, info->wr_id);
 	if (!wqe)
 		return I40IW_ERR_QP_TOOMANY_WRS_POSTED;
 
 	read_fence |= info->read_fence;
-
-	qp->sq_wrtrk_array[wqe_idx].wrid = info->wr_id;
-	qp->sq_wrtrk_array[wqe_idx].wr_len = op_info->len;
 	header = LS_64(stag_to_inv, I40IWQPSQ_REMSTAG) |
 	    LS_64(info->op_type, I40IWQPSQ_OPCODE) |
 	    LS_64(op_info->len, I40IWQPSQ_INLINEDATALEN) |
@@ -574,12 +568,9 @@ static enum i40iw_status_code i40iw_stag_local_invalidate(struct i40iw_qp_uk *qp
 	op_info = &info->op.inv_local_stag;
 	local_fence = info->local_fence;
 
-	wqe = i40iw_qp_get_next_send_wqe(qp, &wqe_idx, I40IW_QP_WQE_MIN_SIZE);
+	wqe = i40iw_qp_get_next_send_wqe(qp, &wqe_idx, I40IW_QP_WQE_MIN_SIZE, 0, info->wr_id);
 	if (!wqe)
 		return I40IW_ERR_QP_TOOMANY_WRS_POSTED;
-
-	qp->sq_wrtrk_array[wqe_idx].wrid = info->wr_id;
-	qp->sq_wrtrk_array[wqe_idx].wr_len = 0;
 	set_64bit_val(wqe, 0, 0);
 	set_64bit_val(wqe, 8,
 		      LS_64(op_info->target_stag, I40IWQPSQ_LOCSTAG));
@@ -619,12 +610,9 @@ static enum i40iw_status_code i40iw_mw_bind(struct i40iw_qp_uk *qp,
 	op_info = &info->op.bind_window;
 
 	local_fence |= info->local_fence;
-	wqe = i40iw_qp_get_next_send_wqe(qp, &wqe_idx, I40IW_QP_WQE_MIN_SIZE);
+	wqe = i40iw_qp_get_next_send_wqe(qp, &wqe_idx, I40IW_QP_WQE_MIN_SIZE, 0, info->wr_id);
 	if (!wqe)
 		return I40IW_ERR_QP_TOOMANY_WRS_POSTED;
-
-	qp->sq_wrtrk_array[wqe_idx].wrid = info->wr_id;
-	qp->sq_wrtrk_array[wqe_idx].wr_len = 0;
 	set_64bit_val(wqe, 0, (uintptr_t)op_info->va);
 	set_64bit_val(wqe, 8,
 		      LS_64(op_info->mr_stag, I40IWQPSQ_PARENTMRSTAG) |
@@ -760,7 +748,7 @@ static enum i40iw_status_code i40iw_cq_poll_completion(struct i40iw_cq_uk *cq,
 	enum i40iw_status_code ret_code2 = 0;
 	bool move_cq_head = true;
 	u8 polarity;
-	u8 addl_frag_cnt, addl_wqes = 0;
+	u8 addl_wqes = 0;
 
 	if (cq->avoid_mem_cflct)
 		cqe = (u64 *)I40IW_GET_CURRENT_EXTENDED_CQ_ELEMENT(cq);
@@ -827,11 +815,8 @@ static enum i40iw_status_code i40iw_cq_poll_completion(struct i40iw_cq_uk *cq,
 			info->op_type = (u8)RS_64(qword3, I40IWCQ_OP);
 			sw_wqe = qp->sq_base[wqe_idx].elem;
 			get_64bit_val(sw_wqe, 24, &wqe_qword);
-			addl_frag_cnt =
-			    (u8)RS_64(wqe_qword, I40IWQPSQ_ADDFRAGCNT);
-			i40iw_fragcnt_to_wqesize_sq(addl_frag_cnt + 1, &addl_wqes);
 
-			addl_wqes = (addl_wqes / I40IW_QP_WQE_MIN_SIZE);
+			addl_wqes = qp->sq_wrtrk_array[wqe_idx].wqe_size / I40IW_QP_WQE_MIN_SIZE;
 			I40IW_RING_SET_TAIL(qp->sq_ring, (wqe_idx + addl_wqes));
 		} else {
 			do {
@@ -843,9 +828,7 @@ static enum i40iw_status_code i40iw_cq_poll_completion(struct i40iw_cq_uk *cq,
 				get_64bit_val(sw_wqe, 24, &wqe_qword);
 				op_type = (u8)RS_64(wqe_qword, I40IWQPSQ_OPCODE);
 				info->op_type = op_type;
-				addl_frag_cnt = (u8)RS_64(wqe_qword, I40IWQPSQ_ADDFRAGCNT);
-				i40iw_fragcnt_to_wqesize_sq(addl_frag_cnt + 1, &addl_wqes);
-				addl_wqes = (addl_wqes / I40IW_QP_WQE_MIN_SIZE);
+				addl_wqes = qp->sq_wrtrk_array[tail].wqe_size / I40IW_QP_WQE_MIN_SIZE;
 				I40IW_RING_SET_TAIL(qp->sq_ring, (tail + addl_wqes));
 				if (op_type != I40IWQP_OP_NOP) {
 					info->wr_id = qp->sq_wrtrk_array[tail].wrid;
@@ -893,19 +876,21 @@ static enum i40iw_status_code i40iw_cq_poll_completion(struct i40iw_cq_uk *cq,
  * i40iw_get_wqe_shift - get shift count for maximum wqe size
  * @wqdepth: depth of wq required.
  * @sge: Maximum Scatter Gather Elements wqe
+ * @inline_data: Maximum inline data size
  * @shift: Returns the shift needed based on sge
  *
- * Shift can be used to left shift the wqe size based on sge.
- * If sge, == 1, shift =0 (wqe_size of 32 bytes), for sge=2 and 3, shift =1
- * (64 bytes wqes) and 2 otherwise (128 bytes wqe).
+ * Shift can be used to left shift the wqe size based on number of SGEs and inlind data size.
+ * For 1 SGE or inline data <= 16, shift = 0 (wqe size of 32 bytes).
+ * For 2 or 3 SGEs or inline data <= 48, shift = 1 (wqe size of 64 bytes).
+ * Shift of 2 otherwise (wqe size of 128 bytes).
  */
-enum i40iw_status_code i40iw_get_wqe_shift(u32 wqdepth, u8 sge, u8 *shift)
+enum i40iw_status_code i40iw_get_wqe_shift(u32 wqdepth, u32 sge, u32 inline_data, u8 *shift)
 {
 	u32 size;
 
 	*shift = 0;
-	if (sge > 1)
-		*shift = (sge < 4) ? 1 : 2;
+	if (sge > 1 || inline_data > 16)
+		*shift = (sge < 4 && inline_data <= 48) ? 1 : 2;
 
 	/* check if wqdepth is multiple of 2 or not */
 
@@ -968,11 +953,11 @@ enum i40iw_status_code i40iw_qp_uk_init(struct i40iw_qp_uk *qp,
 
 	if (info->max_rq_frag_cnt > I40IW_MAX_WQ_FRAGMENT_COUNT)
 		return I40IW_ERR_INVALID_FRAG_COUNT;
-	ret_code = i40iw_get_wqe_shift(info->sq_size, info->max_sq_frag_cnt, &sqshift);
+	ret_code = i40iw_get_wqe_shift(info->sq_size, info->max_sq_frag_cnt, info->max_inline_data, &sqshift);
 	if (ret_code)
 		return ret_code;
 
-	ret_code = i40iw_get_wqe_shift(info->rq_size, info->max_rq_frag_cnt, &rqshift);
+	ret_code = i40iw_get_wqe_shift(info->rq_size, info->max_rq_frag_cnt, 0, &rqshift);
 	if (ret_code)
 		return ret_code;
 
@@ -1097,12 +1082,9 @@ enum i40iw_status_code i40iw_nop(struct i40iw_qp_uk *qp,
 	u64 header, *wqe;
 	u32 wqe_idx;
 
-	wqe = i40iw_qp_get_next_send_wqe(qp, &wqe_idx, I40IW_QP_WQE_MIN_SIZE);
+	wqe = i40iw_qp_get_next_send_wqe(qp, &wqe_idx, I40IW_QP_WQE_MIN_SIZE, 0, wr_id);
 	if (!wqe)
 		return I40IW_ERR_QP_TOOMANY_WRS_POSTED;
-
-	qp->sq_wrtrk_array[wqe_idx].wrid = wr_id;
-	qp->sq_wrtrk_array[wqe_idx].wr_len = 0;
 	set_64bit_val(wqe, 0, 0);
 	set_64bit_val(wqe, 8, 0);
 	set_64bit_val(wqe, 16, 0);
@@ -1125,7 +1107,7 @@ enum i40iw_status_code i40iw_nop(struct i40iw_qp_uk *qp,
  * @frag_cnt: number of fragments
  * @wqe_size: size of sq wqe returned
  */
-enum i40iw_status_code i40iw_fragcnt_to_wqesize_sq(u8 frag_cnt, u8 *wqe_size)
+enum i40iw_status_code i40iw_fragcnt_to_wqesize_sq(u32 frag_cnt, u8 *wqe_size)
 {
 	switch (frag_cnt) {
 	case 0:
@@ -1156,7 +1138,7 @@ enum i40iw_status_code i40iw_fragcnt_to_wqesize_sq(u8 frag_cnt, u8 *wqe_size)
  * @frag_cnt: number of fragments
  * @wqe_size: size of rq wqe returned
  */
-enum i40iw_status_code i40iw_fragcnt_to_wqesize_rq(u8 frag_cnt, u8 *wqe_size)
+enum i40iw_status_code i40iw_fragcnt_to_wqesize_rq(u32 frag_cnt, u8 *wqe_size)
 {
 	switch (frag_cnt) {
 	case 0:
diff --git a/drivers/infiniband/hw/i40iw/i40iw_user.h b/drivers/infiniband/hw/i40iw/i40iw_user.h
index eac9524..4627646 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_user.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_user.h
@@ -61,7 +61,7 @@ enum i40iw_device_capabilities_const {
 	I40IW_MAX_CQ_SIZE =			1048575,
 	I40IW_MAX_AEQ_ALLOCATE_COUNT =		255,
 	I40IW_DB_ID_ZERO =			0,
-	I40IW_MAX_WQ_FRAGMENT_COUNT =		6,
+	I40IW_MAX_WQ_FRAGMENT_COUNT =		3,
 	I40IW_MAX_SGE_RD =			1,
 	I40IW_MAX_OUTBOUND_MESSAGE_SIZE =	2147483647,
 	I40IW_MAX_INBOUND_MESSAGE_SIZE =	2147483647,
@@ -70,8 +70,8 @@ enum i40iw_device_capabilities_const {
 	I40IW_MAX_VF_FPM_ID =			47,
 	I40IW_MAX_VF_PER_PF =			127,
 	I40IW_MAX_SQ_PAYLOAD_SIZE =		2145386496,
-	I40IW_MAX_INLINE_DATA_SIZE =		112,
-	I40IW_MAX_PUSHMODE_INLINE_DATA_SIZE =	112,
+	I40IW_MAX_INLINE_DATA_SIZE =		48,
+	I40IW_MAX_PUSHMODE_INLINE_DATA_SIZE =	48,
 	I40IW_MAX_IRD_SIZE =			32,
 	I40IW_QPCTX_ENCD_MAXIRD =		3,
 	I40IW_MAX_WQ_ENTRIES =			2048,
@@ -200,7 +200,7 @@ enum i40iw_completion_notify {
 
 struct i40iw_post_send {
 	i40iw_sgl sg_list;
-	u8 num_sges;
+	u32 num_sges;
 };
 
 struct i40iw_post_inline_send {
@@ -222,7 +222,7 @@ struct i40iw_post_inline_send_w_inv {
 
 struct i40iw_rdma_write {
 	i40iw_sgl lo_sg_list;
-	u8 num_lo_sges;
+	u32 num_lo_sges;
 	struct i40iw_sge rem_addr;
 };
 
@@ -347,7 +347,9 @@ struct i40iw_dev_uk {
 
 struct i40iw_sq_uk_wr_trk_info {
 	u64 wrid;
-	u64 wr_len;
+	u32 wr_len;
+	u8 wqe_size;
+	u8 reserved[3];
 };
 
 struct i40iw_qp_quanta {
@@ -369,6 +371,8 @@ struct i40iw_qp_uk {
 	u32 qp_id;
 	u32 sq_size;
 	u32 rq_size;
+	u32 max_sq_frag_cnt;
+	u32 max_rq_frag_cnt;
 	struct i40iw_qp_uk_ops ops;
 	bool use_srq;
 	u8 swqe_polarity;
@@ -376,8 +380,6 @@ struct i40iw_qp_uk {
 	u8 rwqe_polarity;
 	u8 rq_wqe_size;
 	u8 rq_wqe_size_multiplier;
-	u8 max_sq_frag_cnt;
-	u8 max_rq_frag_cnt;
 	bool deferred_flag;
 };
 
@@ -406,8 +408,9 @@ struct i40iw_qp_uk_init_info {
 	u32 qp_id;
 	u32 sq_size;
 	u32 rq_size;
-	u8 max_sq_frag_cnt;
-	u8 max_rq_frag_cnt;
+	u32 max_sq_frag_cnt;
+	u32 max_rq_frag_cnt;
+	u32 max_inline_data;
 
 };
 
@@ -424,7 +427,10 @@ void i40iw_device_init_uk(struct i40iw_dev_uk *dev);
 
 void i40iw_qp_post_wr(struct i40iw_qp_uk *qp);
 u64 *i40iw_qp_get_next_send_wqe(struct i40iw_qp_uk *qp, u32 *wqe_idx,
-				u8 wqe_size);
+				u8 wqe_size,
+				u32 total_size,
+				u64 wr_id
+				);
 u64 *i40iw_qp_get_next_recv_wqe(struct i40iw_qp_uk *qp, u32 *wqe_idx);
 u64 *i40iw_qp_get_next_srq_wqe(struct i40iw_srq_uk *srq, u32 *wqe_idx);
 
@@ -436,9 +442,9 @@ enum i40iw_status_code i40iw_qp_uk_init(struct i40iw_qp_uk *qp,
 void i40iw_clean_cq(void *queue, struct i40iw_cq_uk *cq);
 enum i40iw_status_code i40iw_nop(struct i40iw_qp_uk *qp, u64 wr_id,
 				 bool signaled, bool post_sq);
-enum i40iw_status_code i40iw_fragcnt_to_wqesize_sq(u8 frag_cnt, u8 *wqe_size);
-enum i40iw_status_code i40iw_fragcnt_to_wqesize_rq(u8 frag_cnt, u8 *wqe_size);
+enum i40iw_status_code i40iw_fragcnt_to_wqesize_sq(u32 frag_cnt, u8 *wqe_size);
+enum i40iw_status_code i40iw_fragcnt_to_wqesize_rq(u32 frag_cnt, u8 *wqe_size);
 enum i40iw_status_code i40iw_inline_data_size_to_wqesize(u32 data_size,
 							 u8 *wqe_size);
-enum i40iw_status_code i40iw_get_wqe_shift(u32 wqdepth, u8 sge, u8 *shift);
+enum i40iw_status_code i40iw_get_wqe_shift(u32 wqdepth, u32 sge, u32 inline_data, u8 *shift);
 #endif
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index d7c4dd1..329f59a 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -526,9 +526,9 @@ static int i40iw_setup_kmode_qp(struct i40iw_device *iwdev,
 	sq_size = i40iw_qp_roundup(ukinfo->sq_size + 1);
 	rq_size = i40iw_qp_roundup(ukinfo->rq_size + 1);
 
-	status = i40iw_get_wqe_shift(sq_size, ukinfo->max_sq_frag_cnt, &sqshift);
+	status = i40iw_get_wqe_shift(sq_size, ukinfo->max_sq_frag_cnt, ukinfo->max_inline_data, &sqshift);
 	if (!status)
-		status = i40iw_get_wqe_shift(rq_size, ukinfo->max_rq_frag_cnt, &rqshift);
+		status = i40iw_get_wqe_shift(rq_size, ukinfo->max_rq_frag_cnt, 0, &rqshift);
 
 	if (status)
 		return -ENOSYS;
@@ -609,6 +609,9 @@ static struct ib_qp *i40iw_create_qp(struct ib_pd *ibpd,
 	if (init_attr->cap.max_inline_data > I40IW_MAX_INLINE_DATA_SIZE)
 		init_attr->cap.max_inline_data = I40IW_MAX_INLINE_DATA_SIZE;
 
+	if (init_attr->cap.max_send_sge > I40IW_MAX_WQ_FRAGMENT_COUNT)
+		init_attr->cap.max_send_sge = I40IW_MAX_WQ_FRAGMENT_COUNT;
+
 	memset(&init_info, 0, sizeof(init_info));
 
 	sq_size = init_attr->cap.max_send_wr;
@@ -618,6 +621,7 @@ static struct ib_qp *i40iw_create_qp(struct ib_pd *ibpd,
 	init_info.qp_uk_init_info.rq_size = rq_size;
 	init_info.qp_uk_init_info.max_sq_frag_cnt = init_attr->cap.max_send_sge;
 	init_info.qp_uk_init_info.max_rq_frag_cnt = init_attr->cap.max_recv_sge;
+	init_info.qp_uk_init_info.max_inline_data = init_attr->cap.max_inline_data;
 
 	mem = kzalloc(sizeof(*iwqp), GFP_KERNEL);
 	if (!mem)
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
