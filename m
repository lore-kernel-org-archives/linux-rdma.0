From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 31/31] staging/rdma/hfi1: Remove hfi1_query_qp function
Date: Tue, 19 Jan 2016 14:44:17 -0800
Message-ID: <20160119224416.32765.16388.stgit@scvm10.sc.intel.com>
References: <20160119223610.32765.10571.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160119223610.32765.10571.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Rely on rvt_query_qp function defined in rdmavt

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/qp.c    |   50 -------------------------------------
 drivers/staging/rdma/hfi1/qp.h    |    3 --
 drivers/staging/rdma/hfi1/verbs.c |    1 -
 3 files changed, 0 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index c940ad6..f807bca 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -220,56 +220,6 @@ void hfi1_modify_qp(struct rvt_qp *qp, struct ib_qp_attr *attr,
 	}
 }
 
-int hfi1_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
-		  int attr_mask, struct ib_qp_init_attr *init_attr)
-{
-	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
-
-	attr->qp_state = qp->state;
-	attr->cur_qp_state = attr->qp_state;
-	attr->path_mtu = qp->path_mtu;
-	attr->path_mig_state = qp->s_mig_state;
-	attr->qkey = qp->qkey;
-	attr->rq_psn = mask_psn(qp->r_psn);
-	attr->sq_psn = mask_psn(qp->s_next_psn);
-	attr->dest_qp_num = qp->remote_qpn;
-	attr->qp_access_flags = qp->qp_access_flags;
-	attr->cap.max_send_wr = qp->s_size - 1;
-	attr->cap.max_recv_wr = qp->ibqp.srq ? 0 : qp->r_rq.size - 1;
-	attr->cap.max_send_sge = qp->s_max_sge;
-	attr->cap.max_recv_sge = qp->r_rq.max_sge;
-	attr->cap.max_inline_data = 0;
-	attr->ah_attr = qp->remote_ah_attr;
-	attr->alt_ah_attr = qp->alt_ah_attr;
-	attr->pkey_index = qp->s_pkey_index;
-	attr->alt_pkey_index = qp->s_alt_pkey_index;
-	attr->en_sqd_async_notify = 0;
-	attr->sq_draining = qp->s_draining;
-	attr->max_rd_atomic = qp->s_max_rd_atomic;
-	attr->max_dest_rd_atomic = qp->r_max_rd_atomic;
-	attr->min_rnr_timer = qp->r_min_rnr_timer;
-	attr->port_num = qp->port_num;
-	attr->timeout = qp->timeout;
-	attr->retry_cnt = qp->s_retry_cnt;
-	attr->rnr_retry = qp->s_rnr_retry_cnt;
-	attr->alt_port_num = qp->alt_ah_attr.port_num;
-	attr->alt_timeout = qp->alt_timeout;
-
-	init_attr->event_handler = qp->ibqp.event_handler;
-	init_attr->qp_context = qp->ibqp.qp_context;
-	init_attr->send_cq = qp->ibqp.send_cq;
-	init_attr->recv_cq = qp->ibqp.recv_cq;
-	init_attr->srq = qp->ibqp.srq;
-	init_attr->cap = attr->cap;
-	if (qp->s_flags & RVT_S_SIGNAL_REQ_WR)
-		init_attr->sq_sig_type = IB_SIGNAL_REQ_WR;
-	else
-		init_attr->sq_sig_type = IB_SIGNAL_ALL_WR;
-	init_attr->qp_type = qp->ibqp.qp_type;
-	init_attr->port_num = qp->port_num;
-	return 0;
-}
-
 /**
  * hfi1_compute_aeth - compute the AETH (syndrome + MSN)
  * @qp: the queue pair to compute the AETH for
diff --git a/drivers/staging/rdma/hfi1/qp.h b/drivers/staging/rdma/hfi1/qp.h
index a51da1d..f2e980b 100644
--- a/drivers/staging/rdma/hfi1/qp.h
+++ b/drivers/staging/rdma/hfi1/qp.h
@@ -71,9 +71,6 @@ static inline void clear_ahg(struct rvt_qp *qp)
 	qp->s_ahgidx = -1;
 }
 
-int hfi1_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
-		  int attr_mask, struct ib_qp_init_attr *init_attr);
-
 /**
  * hfi1_compute_aeth - compute the AETH (syndrome + MSN)
  * @qp: the queue pair to compute the AETH for
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 68f4045..f5cc0b9 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -1517,7 +1517,6 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	ibdev->modify_srq = hfi1_modify_srq;
 	ibdev->query_srq = hfi1_query_srq;
 	ibdev->destroy_srq = hfi1_destroy_srq;
-	ibdev->query_qp = hfi1_query_qp;
 	ibdev->post_srq_recv = hfi1_post_srq_receive;
 
 	/* keep process mad in the driver */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
