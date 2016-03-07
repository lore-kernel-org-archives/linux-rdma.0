From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/10] IB/rdmavt: Post receive for QP in ERR state
Date: Mon, 07 Mar 2016 11:35:51 -0800
Message-ID: <20160307193551.4913.27232.stgit@scvm10.sc.intel.com>
References: <20160307193146.4913.42900.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160307193146.4913.42900.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Accordingly IB Spec post WR to receive queue must
complete with error if QP is in Error state.
Please refer to C10-42, C10-97.2.1

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |   33 ++++++++++++++++++++++++---------
 1 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index de34474..bd82a69 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1364,6 +1364,8 @@ int rvt_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
 	struct rvt_rwq *wq = qp->r_rq.wq;
 	unsigned long flags;
+	int qp_err_flush = (ib_rvt_state_ops[qp->state] & RVT_FLUSH_RECV) &&
+				!qp->ibqp.srq;
 
 	/* Check that state is OK to post receive. */
 	if (!(ib_rvt_state_ops[qp->state] & RVT_POST_RECV_OK) || !wq) {
@@ -1390,15 +1392,28 @@ int rvt_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 			*bad_wr = wr;
 			return -ENOMEM;
 		}
-
-		wqe = rvt_get_rwqe_ptr(&qp->r_rq, wq->head);
-		wqe->wr_id = wr->wr_id;
-		wqe->num_sge = wr->num_sge;
-		for (i = 0; i < wr->num_sge; i++)
-			wqe->sg_list[i] = wr->sg_list[i];
-		/* Make sure queue entry is written before the head index. */
-		smp_wmb();
-		wq->head = next;
+		if (unlikely(qp_err_flush)) {
+			struct ib_wc wc;
+
+			memset(&wc, 0, sizeof(wc));
+			wc.qp = &qp->ibqp;
+			wc.opcode = IB_WC_RECV;
+			wc.wr_id = wr->wr_id;
+			wc.status = IB_WC_WR_FLUSH_ERR;
+			rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc, 1);
+		} else {
+			wqe = rvt_get_rwqe_ptr(&qp->r_rq, wq->head);
+			wqe->wr_id = wr->wr_id;
+			wqe->num_sge = wr->num_sge;
+			for (i = 0; i < wr->num_sge; i++)
+				wqe->sg_list[i] = wr->sg_list[i];
+			/*
+			 * Make sure queue entry is written
+			 * before the head index.
+			 */
+			smp_wmb();
+			wq->head = next;
+		}
 		spin_unlock_irqrestore(&qp->r_rq.lock, flags);
 	}
 	return 0;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
