From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 16/16] staging/rdma/hfi1: add cq head and tail information
 to qpstats
Date: Sun, 14 Feb 2016 12:46:28 -0800
Message-ID: <20160214204624.29247.69312.stgit@scvm10.sc.intel.com>
References: <20160214203612.29247.59915.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160214203612.29247.59915.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This enables debugging issues related to cq event signalling mechanism

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/qp.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index 4d5319c..c78b7bd 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -681,7 +681,7 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
 	wqe = rvt_get_swqe_ptr(qp, qp->s_last);
 	send_context = qp_to_send_context(qp, priv->s_sc);
 	seq_printf(s,
-		   "N %d %s QP%x R %u %s %u %u %u f=%x %u %u %u %u %u %u PSN %x %x %x %x %x (%u %u %u %u %u %u %u) QP%x LID %x SL %u MTU %u %u %u %u SDE %p,%u SC %p,%u\n",
+		   "N %d %s QP%x R %u %s %u %u %u f=%x %u %u %u %u %u %u PSN %x %x %x %x %x (%u %u %u %u %u %u %u) QP%x LID %x SL %u MTU %u %u %u %u SDE %p,%u SC %p,%u CQ %u %u\n",
 		   iter->n,
 		   qp_idle(qp) ? "I" : "B",
 		   qp->ibqp.qp_num,
@@ -713,7 +713,9 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
 		   sde,
 		   sde ? sde->this_idx : 0,
 		   send_context,
-		   send_context ? send_context->sw_index : 0);
+		   send_context ? send_context->sw_index : 0,
+		   ibcq_to_rvtcq(qp->ibqp.send_cq)->queue->head,
+		   ibcq_to_rvtcq(qp->ibqp.send_cq)->queue->tail);
 }
 
 void qp_comm_est(struct rvt_qp *qp)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
