From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 09/27] IB/hfi1: Add additional fields to qp_stats
Date: Wed, 08 Feb 2017 05:26:43 -0800
Message-ID: <20170208132642.16442.352.stgit@scvm10.sc.intel.com>
References: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208132142.16442.69329.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The r_psn and s_rnr_retry are missing.

Add with this patch.

Reviewed-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/qp.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index c2a166d..48d59e7 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -744,7 +744,7 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
 	wqe = rvt_get_swqe_ptr(qp, qp->s_last);
 	send_context = qp_to_send_context(qp, priv->s_sc);
 	seq_printf(s,
-		   "N %d %s QP %x R %u %s %u %u %u f=%x %u %u %u %u %u %u PSN %x %x %x %x %x (%u %u %u %u %u %u %u) RQP %x LID %x SL %u MTU %u %u %u %u SDE %p,%u SC %p,%u SCQ %u %u PID %d\n",
+		   "N %d %s QP %x R %u %s %u %u %u f=%x %u %u %u %u %u %u SPSN %x %x %x %x %x RPSN %x (%u %u %u %u %u %u %u) RQP %x LID %x SL %u MTU %u %u %u %u %u SDE %p,%u SC %p,%u SCQ %u %u PID %d\n",
 		   iter->n,
 		   qp_idle(qp) ? "I" : "B",
 		   qp->ibqp.qp_num,
@@ -763,6 +763,7 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
 		   qp->s_last_psn,
 		   qp->s_psn, qp->s_next_psn,
 		   qp->s_sending_psn, qp->s_sending_hpsn,
+		   qp->r_psn,
 		   qp->s_last, qp->s_acked, qp->s_cur,
 		   qp->s_tail, qp->s_head, qp->s_size,
 		   qp->s_avail,
@@ -773,6 +774,7 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
 		   qp->s_retry,
 		   qp->s_retry_cnt,
 		   qp->s_rnr_retry_cnt,
+		   qp->s_rnr_retry,
 		   sde,
 		   sde ? sde->this_idx : 0,
 		   send_context,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
