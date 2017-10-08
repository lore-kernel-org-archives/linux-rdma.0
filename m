From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-core] providers/i40iw: Do not generate CQE for RTR on QP flush
Date: Sun,  8 Oct 2017 18:37:41 -0500
Message-ID: <20171008233741.9168-1-tatyana.e.nikolova@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

If RTR WQE is posted and QP is flushed, a CQE is
incorrectly generated for the RTR WQE. Add code
to look for the RTR and not generate a CQE when
QP is flushed.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 providers/i40iw/i40iw_uk.c   | 12 ++++++++++++
 providers/i40iw/i40iw_user.h |  1 +
 2 files changed, 13 insertions(+)

diff --git a/providers/i40iw/i40iw_uk.c b/providers/i40iw/i40iw_uk.c
index ea3255f7..4c7e5cff 100644
--- a/providers/i40iw/i40iw_uk.c
+++ b/providers/i40iw/i40iw_uk.c
@@ -829,6 +829,17 @@ static enum i40iw_status_code i40iw_cq_poll_completion(struct i40iw_cq_uk *cq,
 		I40IW_RING_SET_TAIL(qp->rq_ring, array_idx + 1);
 		pring = &qp->rq_ring;
 	} else {
+		if (qp->first_sq_wq) {
+			qp->first_sq_wq = false;
+			if (!wqe_idx && (qp->sq_ring.head == qp->sq_ring.tail)) {
+				I40IW_RING_MOVE_HEAD_NOCHECK(cq->cq_ring);
+				I40IW_RING_MOVE_TAIL(cq->cq_ring);
+				set_64bit_val(cq->shadow_area, I40IW_BYTE_0,
+					      I40IW_RING_GETCURRENT_HEAD(cq->cq_ring));
+				memset(info, 0, sizeof(struct i40iw_cq_poll_info));
+				return i40iw_cq_poll_completion(cq, info);
+			}
+		}
 
 		if (info->comp_status != I40IW_COMPL_STATUS_FLUSHED) {
 			info->wr_id = qp->sq_wrtrk_array[wqe_idx].wrid;
@@ -997,6 +1008,7 @@ enum i40iw_status_code i40iw_qp_uk_init(struct i40iw_qp_uk *qp,
 	I40IW_RING_MOVE_TAIL(qp->sq_ring);
 	I40IW_RING_MOVE_HEAD(qp->initial_ring, ret_code);
 	qp->swqe_polarity = 1;
+	qp->first_sq_wq = true;
 	qp->swqe_polarity_deferred = 1;
 	qp->rwqe_polarity = 0;
 
diff --git a/providers/i40iw/i40iw_user.h b/providers/i40iw/i40iw_user.h
index 1e95c23a..7bceca43 100644
--- a/providers/i40iw/i40iw_user.h
+++ b/providers/i40iw/i40iw_user.h
@@ -382,6 +382,7 @@ struct i40iw_qp_uk {
 	u8 rwqe_polarity;
 	u8 rq_wqe_size;
 	u8 rq_wqe_size_multiplier;
+	bool first_sq_wq;
 	bool deferred_flag;
 };
 
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
