From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 03/10] IB/hfi1: Fix issues with qp_stats print
Date: Mon, 07 Mar 2016 11:35:14 -0800
Message-ID: <20160307193513.4913.15082.stgit@scvm10.sc.intel.com>
References: <20160307193146.4913.42900.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160307193146.4913.42900.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The changes are to aid in coorelating trace information
with QPs between the trace and qp_stats information

Such changes include adds a space after QP and clarifying that the second
QP is actually the remote QP.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/qp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index a97c182..ce5d2c2 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -678,7 +678,7 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
 	wqe = rvt_get_swqe_ptr(qp, qp->s_last);
 	send_context = qp_to_send_context(qp, priv->s_sc);
 	seq_printf(s,
-		   "N %d %s QP%x R %u %s %u %u %u f=%x %u %u %u %u %u %u PSN %x %x %x %x %x (%u %u %u %u %u %u %u) QP%x LID %x SL %u MTU %u %u %u %u SDE %p,%u SC %p,%u CQ %u %u PID %d\n",
+		   "N %d %s QP %x R %u %s %u %u %u f=%x %u %u %u %u %u %u PSN %x %x %x %x %x (%u %u %u %u %u %u %u) RQP %x LID %x SL %u MTU %u %u %u %u SDE %p,%u SC %p,%u SCQ %u %u PID %d\n",
 		   iter->n,
 		   qp_idle(qp) ? "I" : "B",
 		   qp->ibqp.qp_num,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
