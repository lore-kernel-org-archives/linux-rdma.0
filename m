From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 6/6] IB/rdmavt: Add support for rvt_query_qp
Date: Fri, 22 Jan 2016 13:05:04 -0800
Message-ID: <20160122210503.9932.70752.stgit@scvm10.sc.intel.com>
References: <20160122210251.9932.46251.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160122210251.9932.46251.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Drivers using rdmavt can rely on rvt_query_qp instead of defining their own
query_qp functions.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |   47 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 46 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 8d3563a..354fdac 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1239,7 +1239,52 @@ int rvt_destroy_qp(struct ib_qp *ibqp)
 int rvt_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		 int attr_mask, struct ib_qp_init_attr *init_attr)
 {
-	return -EOPNOTSUPP;
+	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
+	struct rvt_dev_info *rdi = ib_to_rvt(ibqp->device);
+
+	attr->qp_state = qp->state;
+	attr->cur_qp_state = attr->qp_state;
+	attr->path_mtu = qp->path_mtu;
+	attr->path_mig_state = qp->s_mig_state;
+	attr->qkey = qp->qkey;
+	attr->rq_psn = qp->r_psn & rdi->dparms.psn_mask;
+	attr->sq_psn = qp->s_next_psn & rdi->dparms.psn_mask;
+	attr->dest_qp_num = qp->remote_qpn;
+	attr->qp_access_flags = qp->qp_access_flags;
+	attr->cap.max_send_wr = qp->s_size - 1;
+	attr->cap.max_recv_wr = qp->ibqp.srq ? 0 : qp->r_rq.size - 1;
+	attr->cap.max_send_sge = qp->s_max_sge;
+	attr->cap.max_recv_sge = qp->r_rq.max_sge;
+	attr->cap.max_inline_data = 0;
+	attr->ah_attr = qp->remote_ah_attr;
+	attr->alt_ah_attr = qp->alt_ah_attr;
+	attr->pkey_index = qp->s_pkey_index;
+	attr->alt_pkey_index = qp->s_alt_pkey_index;
+	attr->en_sqd_async_notify = 0;
+	attr->sq_draining = qp->s_draining;
+	attr->max_rd_atomic = qp->s_max_rd_atomic;
+	attr->max_dest_rd_atomic = qp->r_max_rd_atomic;
+	attr->min_rnr_timer = qp->r_min_rnr_timer;
+	attr->port_num = qp->port_num;
+	attr->timeout = qp->timeout;
+	attr->retry_cnt = qp->s_retry_cnt;
+	attr->rnr_retry = qp->s_rnr_retry_cnt;
+	attr->alt_port_num = qp->alt_ah_attr.port_num;
+	attr->alt_timeout = qp->alt_timeout;
+
+	init_attr->event_handler = qp->ibqp.event_handler;
+	init_attr->qp_context = qp->ibqp.qp_context;
+	init_attr->send_cq = qp->ibqp.send_cq;
+	init_attr->recv_cq = qp->ibqp.recv_cq;
+	init_attr->srq = qp->ibqp.srq;
+	init_attr->cap = attr->cap;
+	if (qp->s_flags & RVT_S_SIGNAL_REQ_WR)
+		init_attr->sq_sig_type = IB_SIGNAL_REQ_WR;
+	else
+		init_attr->sq_sig_type = IB_SIGNAL_ALL_WR;
+	init_attr->qp_type = qp->ibqp.qp_type;
+	init_attr->port_num = qp->port_num;
+	return 0;
 }
 
 /**

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
