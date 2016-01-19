From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 7/7] IB/qib: Remove qib_query_qp function
Date: Tue, 19 Jan 2016 14:34:01 -0800
Message-ID: <20160119223401.30925.25087.stgit@scvm10.sc.intel.com>
References: <20160119223130.30925.93860.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160119223130.30925.93860.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Rely on rvt_query_qp function defined in rdmavt

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_qp.c    |   50 ---------------------------------
 drivers/infiniband/hw/qib/qib_verbs.c |    3 +-
 drivers/infiniband/hw/qib/qib_verbs.h |    3 --
 3 files changed, 2 insertions(+), 54 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index df55d49..515ec82 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -802,56 +802,6 @@ bail:
 	return ret;
 }
 
-int qib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
-		 int attr_mask, struct ib_qp_init_attr *init_attr)
-{
-	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
-
-	attr->qp_state = qp->state;
-	attr->cur_qp_state = attr->qp_state;
-	attr->path_mtu = qp->path_mtu;
-	attr->path_mig_state = qp->s_mig_state;
-	attr->qkey = qp->qkey;
-	attr->rq_psn = qp->r_psn & QIB_PSN_MASK;
-	attr->sq_psn = qp->s_next_psn & QIB_PSN_MASK;
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
  * qib_compute_aeth - compute the AETH (syndrome + MSN)
  * @qp: the queue pair to compute the AETH for
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index cbf5f88..8b97ca1 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1760,7 +1760,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->destroy_srq = qib_destroy_srq;
 	ibdev->create_qp = NULL;
 	ibdev->modify_qp = qib_modify_qp;
-	ibdev->query_qp = qib_query_qp;
+	ibdev->query_qp = NULL;
 	ibdev->destroy_qp = qib_destroy_qp;
 	ibdev->post_send = NULL;
 	ibdev->post_recv = NULL;
@@ -1814,6 +1814,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	dd->verbs_dev.rdi.dparms.qpn_res_end = QIB_KD_QP; /* Reserve one QP */
 	dd->verbs_dev.rdi.dparms.qpn_inc = 1;
 	dd->verbs_dev.rdi.dparms.qos_shift = 1;
+	dd->verbs_dev.rdi.dparms.psn_mask = QIB_PSN_MASK;
 	dd->verbs_dev.rdi.dparms.nports = dd->num_pports;
 	dd->verbs_dev.rdi.dparms.npkeys = qib_get_npkeys(dd);
 	dd->verbs_dev.rdi.dparms.node = dd->assigned_node_id;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 6b1e56b..c87a0bf 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -369,9 +369,6 @@ int qib_error_qp(struct rvt_qp *qp, enum ib_wc_status err);
 
 int qib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		  int attr_mask, struct ib_udata *udata);
-
-int qib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
-		 int attr_mask, struct ib_qp_init_attr *init_attr);
 /*
  * Functions provided by qib driver for rdmavt to use
  */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
