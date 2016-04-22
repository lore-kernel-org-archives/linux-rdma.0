From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/7] RDMA/i40iw: Fixes for WQE alignment
Date: Fri, 22 Apr 2016 14:14:23 -0500
Message-ID: <1461352469-16504-2-git-send-email-tatyana.e.nikolova@intel.com>
References: <1461352469-16504-1-git-send-email-tatyana.e.nikolova@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461352469-16504-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Invalidation after every WQE write is changed to invalidate
only if required. NOPs are padded so that WQE writes are
aligned to 64B boundary.

Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_d.h  |  2 ++
 drivers/infiniband/hw/i40iw/i40iw_uk.c | 18 ++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_d.h b/drivers/infiniband/hw/i40iw/i40iw_d.h
index e8951a7..bd942da 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_d.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_d.h
@@ -1512,6 +1512,8 @@ enum i40iw_alignment {
 	I40IW_SD_BUF_ALIGNMENT =	0x100
 };
 
+#define I40IW_WQE_SIZE_64	64
+
 #define I40IW_QP_WQE_MIN_SIZE	32
 #define I40IW_QP_WQE_MAX_SIZE	128
 
diff --git a/drivers/infiniband/hw/i40iw/i40iw_uk.c b/drivers/infiniband/hw/i40iw/i40iw_uk.c
index 9e3a700..6e0e327 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_uk.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_uk.c
@@ -162,6 +162,17 @@ u64 *i40iw_qp_get_next_send_wqe(struct i40iw_qp_uk *qp,
 		if (!*wqe_idx)
 			qp->swqe_polarity = !qp->swqe_polarity;
 	}
+
+	if (((*wqe_idx & 3) == 1) && (wqe_size == I40IW_WQE_SIZE_64)) {
+		i40iw_nop_1(qp);
+		I40IW_RING_MOVE_HEAD(qp->sq_ring, ret_code);
+		if (ret_code)
+			return NULL;
+		*wqe_idx = I40IW_RING_GETCURRENT_HEAD(qp->sq_ring);
+		if (!*wqe_idx)
+			qp->swqe_polarity = !qp->swqe_polarity;
+	}
+
 	for (i = 0; i < wqe_size / I40IW_QP_WQE_MIN_SIZE; i++) {
 		I40IW_RING_MOVE_HEAD(qp->sq_ring, ret_code);
 		if (ret_code)
@@ -172,8 +183,11 @@ u64 *i40iw_qp_get_next_send_wqe(struct i40iw_qp_uk *qp,
 
 	peek_head = I40IW_RING_GETCURRENT_HEAD(qp->sq_ring);
 	wqe_0 = qp->sq_base[peek_head].elem;
-	if (peek_head & 0x3)
-		wqe_0[3] = LS_64(!qp->swqe_polarity, I40IWQPSQ_VALID);
+
+	if (((peek_head & 3) == 1) || ((peek_head & 3) == 3)) {
+		if (RS_64(wqe_0[3], I40IWQPSQ_VALID) != !qp->swqe_polarity)
+			wqe_0[3] = LS_64(!qp->swqe_polarity, I40IWQPSQ_VALID);
+	}
 
 	qp->sq_wrtrk_array[*wqe_idx].wrid = wr_id;
 	qp->sq_wrtrk_array[*wqe_idx].wr_len = total_size;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
