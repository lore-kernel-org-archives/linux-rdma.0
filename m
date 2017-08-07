From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/7] i40iw: Ignore first SQ wqe_index if it shows up as a CQE
Date: Mon,  7 Aug 2017 16:31:58 -0500
Message-ID: <20170807213203.30588-3-henry.orosco@intel.com>
References: <20170807213203.30588-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170807213203.30588-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Christopher N Bednarz <christopher.n.bednarz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Christopher N Bednarz <christopher.n.bednarz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

If a QP flush occurs while RTR WQE is posted but not completed,
then upper layers may interpret its completion as a spurious
WQE. Fix this by skipping the wqe_idx of 0 when polling the
CQ while also awaiting the completion of the RTR WQE. Continue
processing any remaining entries.

Signed-off-by: Christopher N Bednarz <christopher.n.bednarz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c  |  1 +
 drivers/infiniband/hw/i40iw/i40iw_uk.c    | 13 +++++++++++++
 drivers/infiniband/hw/i40iw/i40iw_user.h  |  2 ++
 drivers/infiniband/hw/i40iw/i40iw_verbs.c |  1 +
 4 files changed, 17 insertions(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
index 6779b4b..5769080 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
@@ -2346,6 +2346,7 @@ static enum i40iw_status_code i40iw_sc_qp_init(struct i40iw_sc_qp *qp,
 	qp->rq_tph_en = info->rq_tph_en;
 	qp->rcv_tph_en = info->rcv_tph_en;
 	qp->xmit_tph_en = info->xmit_tph_en;
+	qp->qp_uk.first_sq_wq = info->qp_uk_init_info.first_sq_wq;
 	qp->qs_handle = qp->vsi->qos[qp->user_pri].qs_handle;
 	qp->exception_lan_queue = qp->pd->dev->exception_lan_queue;
 
diff --git a/drivers/infiniband/hw/i40iw/i40iw_uk.c b/drivers/infiniband/hw/i40iw/i40iw_uk.c
index b0d3a0e..f963340 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_uk.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_uk.c
@@ -821,6 +821,19 @@ static enum i40iw_status_code i40iw_cq_poll_completion(struct i40iw_cq_uk *cq,
 		I40IW_RING_SET_TAIL(qp->rq_ring, array_idx + 1);
 		pring = &qp->rq_ring;
 	} else {
+
+		if (qp->first_sq_wq) {
+			qp->first_sq_wq = 0;
+			if (!wqe_idx) {
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
diff --git a/drivers/infiniband/hw/i40iw/i40iw_user.h b/drivers/infiniband/hw/i40iw/i40iw_user.h
index 84be6f1..104a9c5 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_user.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_user.h
@@ -377,6 +377,7 @@ struct i40iw_qp_uk {
 	u8 rq_wqe_size;
 	u8 rq_wqe_size_multiplier;
 	bool deferred_flag;
+	u8 first_sq_wq;
 };
 
 struct i40iw_cq_uk {
@@ -408,6 +409,7 @@ struct i40iw_qp_uk_init_info {
 	u32 max_rq_frag_cnt;
 	u32 max_inline_data;
 	int abi_ver;
+	u8 first_sq_wq;
 };
 
 struct i40iw_cq_uk_init_info {
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 02d871d..742893a 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -672,6 +672,7 @@ static struct ib_qp *i40iw_create_qp(struct ib_pd *ibpd,
 
 	init_info.pd = &iwpd->sc_pd;
 	init_info.qp_uk_init_info.qp_id = iwqp->ibqp.qp_num;
+	init_info.qp_uk_init_info.first_sq_wq = 1;
 	iwqp->ctx_info.qp_compl_ctx = (uintptr_t)qp;
 
 	if (init_attr->qp_type != IB_QPT_RC) {
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
