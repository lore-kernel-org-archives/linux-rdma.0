From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1 2/5] i40iw: Do not generate CQE for RTR on QP flush
Date: Tue,  3 Oct 2017 11:11:47 -0500
Message-ID: <20171003161150.16172-3-shiraz.saleem@intel.com>
References: <20171003161150.16172-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171003161150.16172-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

If RTR WQE is posted and QP is flushed, a CQE is
incorrectly generated for the RTR WQE. Add code
to look for the RTR and not generate a CQE when
QP is flushed.

Fixes: 280cfc4b74e6 ("i40iw: user kernel shared files")
Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_uk.c   | 13 +++++++++++++
 drivers/infiniband/hw/i40iw/i40iw_user.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_uk.c b/drivers/infiniband/hw/i40iw/i40iw_uk.c
index 0aadb7a..42dde59 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_uk.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_uk.c
@@ -821,6 +821,18 @@ static enum i40iw_status_code i40iw_cq_poll_completion(struct i40iw_cq_uk *cq,
 		I40IW_RING_SET_TAIL(qp->rq_ring, array_idx + 1);
 		pring = &qp->rq_ring;
 	} else {
+		if (qp->first_sq_wq) {
+			qp->first_sq_wq = false;
+			if (!wqe_idx && (qp->sq_ring.head == qp->sq_ring.tail)) {
+				I40IW_RING_MOVE_HEAD_NOCHECK(cq->cq_ring);
+				I40IW_RING_MOVE_TAIL(cq->cq_ring);
+				set_64bit_val(cq->shadow_area, 0,
+					      I40IW_RING_GETCURRENT_HEAD(cq->cq_ring));
+				memset(info, 0, sizeof(struct i40iw_cq_poll_info));
+				return i40iw_cq_poll_completion(cq, info);
+			}
+		}
+
 		if (info->comp_status != I40IW_COMPL_STATUS_FLUSHED) {
 			info->wr_id = qp->sq_wrtrk_array[wqe_idx].wrid;
 			info->bytes_xfered = qp->sq_wrtrk_array[wqe_idx].wr_len;
@@ -988,6 +1000,7 @@ enum i40iw_status_code i40iw_qp_uk_init(struct i40iw_qp_uk *qp,
 	I40IW_RING_MOVE_TAIL(qp->sq_ring);
 	I40IW_RING_MOVE_HEAD(qp->initial_ring, ret_code);
 	qp->swqe_polarity = 1;
+	qp->first_sq_wq = true;
 	qp->swqe_polarity_deferred = 1;
 	qp->rwqe_polarity = 0;
 
diff --git a/drivers/infiniband/hw/i40iw/i40iw_user.h b/drivers/infiniband/hw/i40iw/i40iw_user.h
index 84be6f1..15e8f55 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_user.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_user.h
@@ -376,6 +376,7 @@ struct i40iw_qp_uk {
 	u8 rwqe_polarity;
 	u8 rq_wqe_size;
 	u8 rq_wqe_size_multiplier;
+	bool first_sq_wq;
 	bool deferred_flag;
 };
 
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
