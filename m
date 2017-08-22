From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 15/16] IB/hfi1: Add received request info to
 qp_stats
Date: Mon, 21 Aug 2017 18:27:41 -0700
Message-ID: <20170822012740.32701.30879.stgit@scvm10.sc.intel.com>
References: <20170822011657.32701.22207.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170822011657.32701.22207.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The rvt_ack_entry pointed to by s_tail_ack_queue provides important
info about the request that has just been processed or is being processed
on the responder side of a RC connection. This patch adds this info to
the qp_stats to assist debugging.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/qp.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index 0fca6df..ee836c0 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -626,12 +626,15 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
 	struct hfi1_qp_priv *priv = qp->priv;
 	struct sdma_engine *sde;
 	struct send_context *send_context;
+	struct rvt_ack_entry *e = NULL;
 
 	sde = qp_to_sdma_engine(qp, priv->s_sc);
 	wqe = rvt_get_swqe_ptr(qp, qp->s_last);
 	send_context = qp_to_send_context(qp, priv->s_sc);
+	if (qp->s_ack_queue)
+		e = &qp->s_ack_queue[qp->s_tail_ack_queue];
 	seq_printf(s,
-		   "N %d %s QP %x R %u %s %u %u %u f=%x %u %u %u %u %u %u SPSN %x %x %x %x %x RPSN %x S(%u %u %u %u %u %u %u) R(%u %u %u) RQP %x LID %x SL %u MTU %u %u %u %u %u SDE %p,%u SC %p,%u SCQ %u %u PID %d\n",
+		   "N %d %s QP %x R %u %s %u %u %u f=%x %u %u %u %u %u %u SPSN %x %x %x %x %x RPSN %x S(%u %u %u %u %u %u %u) R(%u %u %u) RQP %x LID %x SL %u MTU %u %u %u %u %u SDE %p,%u SC %p,%u SCQ %u %u PID %d E %x %x %x\n",
 		   iter->n,
 		   qp_idle(qp) ? "I" : "B",
 		   qp->ibqp.qp_num,
@@ -672,7 +675,11 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
 		   send_context ? send_context->sw_index : 0,
 		   ibcq_to_rvtcq(qp->ibqp.send_cq)->queue->head,
 		   ibcq_to_rvtcq(qp->ibqp.send_cq)->queue->tail,
-		   qp->pid);
+		   qp->pid,
+		   /* ack queue information */
+		   e ? e->opcode : 0,
+		   e ? e->psn : 0,
+		   e ? e->lpsn : 0);
 }
 
 void *qp_priv_alloc(struct rvt_dev_info *rdi, struct rvt_qp *qp)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
