From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 1/3] IB/hfi1: Add RQ/SRQ information to QP stats
Date: Fri, 22 Dec 2017 08:45:44 -0800
Message-ID: <20171222164540.29731.68770.stgit@scvm10.sc.intel.com>
References: <20171222164036.29731.43475.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171222164036.29731.43475.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When debugging issues with RC QPs, it is useful to know if a QP
has an associated RQ or SRQ, the size of the RQ, and any RNR timeout
values.

Add the necessary information to the QP stats output.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/qp.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index 4b01ccd..5507910 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -556,6 +556,8 @@ void qp_iter_print(struct seq_file *s, struct rvt_qp_iter *iter)
 	struct sdma_engine *sde;
 	struct send_context *send_context;
 	struct rvt_ack_entry *e = NULL;
+	struct rvt_srq *srq = qp->ibqp.srq ?
+		ibsrq_to_rvtsrq(qp->ibqp.srq) : NULL;
 
 	sde = qp_to_sdma_engine(qp, priv->s_sc);
 	wqe = rvt_get_swqe_ptr(qp, qp->s_last);
@@ -563,7 +565,7 @@ void qp_iter_print(struct seq_file *s, struct rvt_qp_iter *iter)
 	if (qp->s_ack_queue)
 		e = &qp->s_ack_queue[qp->s_tail_ack_queue];
 	seq_printf(s,
-		   "N %d %s QP %x R %u %s %u %u %u f=%x %u %u %u %u %u %u SPSN %x %x %x %x %x RPSN %x S(%u %u %u %u %u %u %u) R(%u %u %u) RQP %x LID %x SL %u MTU %u %u %u %u %u SDE %p,%u SC %p,%u SCQ %u %u PID %d OS %x %x E %x %x %x\n",
+		   "N %d %s QP %x R %u %s %u %u %u f=%x %u %u %u %u %u %u SPSN %x %x %x %x %x RPSN %x S(%u %u %u %u %u %u %u) R(%u %u %u) RQP %x LID %x SL %u MTU %u %u %u %u %u SDE %p,%u SC %p,%u SCQ %u %u PID %d OS %x %x E %x %x %x RNR %d %s %d\n",
 		   iter->n,
 		   qp_idle(qp) ? "I" : "B",
 		   qp->ibqp.qp_num,
@@ -610,7 +612,11 @@ void qp_iter_print(struct seq_file *s, struct rvt_qp_iter *iter)
 		   /* ack queue information */
 		   e ? e->opcode : 0,
 		   e ? e->psn : 0,
-		   e ? e->lpsn : 0);
+		   e ? e->lpsn : 0,
+		   qp->r_min_rnr_timer,
+		   srq ? "SRQ" : "RQ",
+		   srq ? srq->rq.size : qp->r_rq.size
+		);
 }
 
 void *qp_priv_alloc(struct rvt_dev_info *rdi, struct rvt_qp *qp)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
