From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 2/2] IB/hfi1: Add receiving queue info to qp_stats
Date: Sat, 17 Jun 2017 10:37:34 -0700
Message-ID: <20170617173731.17658.61784.stgit@scvm10.sc.intel.com>
References: <20170617173620.17658.5173.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170617173620.17658.5173.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch adds qp->s_ack_queue indices and size to qp_stats printout.
This information will provide information about the receiving side.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/qp.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index e91be05..f1e4bff 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -601,7 +601,7 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
 	wqe = rvt_get_swqe_ptr(qp, qp->s_last);
 	send_context = qp_to_send_context(qp, priv->s_sc);
 	seq_printf(s,
-		   "N %d %s QP %x R %u %s %u %u %u f=%x %u %u %u %u %u %u SPSN %x %x %x %x %x RPSN %x (%u %u %u %u %u %u %u) RQP %x LID %x SL %u MTU %u %u %u %u %u SDE %p,%u SC %p,%u SCQ %u %u PID %d\n",
+		   "N %d %s QP %x R %u %s %u %u %u f=%x %u %u %u %u %u %u SPSN %x %x %x %x %x RPSN %x S(%u %u %u %u %u %u %u) R(%u %u %u) RQP %x LID %x SL %u MTU %u %u %u %u %u SDE %p,%u SC %p,%u SCQ %u %u PID %d\n",
 		   iter->n,
 		   qp_idle(qp) ? "I" : "B",
 		   qp->ibqp.qp_num,
@@ -624,6 +624,10 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
 		   qp->s_last, qp->s_acked, qp->s_cur,
 		   qp->s_tail, qp->s_head, qp->s_size,
 		   qp->s_avail,
+		   /* ack_queue ring pointers, size */
+		   qp->s_tail_ack_queue, qp->r_head_ack_queue,
+		   HFI1_MAX_RDMA_ATOMIC,
+		   /* remote QP info  */
 		   qp->remote_qpn,
 		   rdma_ah_get_dlid(&qp->remote_ah_attr),
 		   rdma_ah_get_sl(&qp->remote_ah_attr),

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
