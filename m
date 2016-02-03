From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 27/54] staging/rdma/hfi1: Allow a fair scheduling of QPs
Date: Wed, 03 Feb 2016 14:34:23 -0800
Message-ID: <20160203223420.5923.85376.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch fixes the fairness issues in QP scheduling
- the timeout for cond_resched is changed to a ratio of
qp->timeout_jiffies
- workqueue_congested is used to determine if qp needs to
reschedule itself

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/ruc.c |   52 +++++++++++++++++++++++++++++----------
 1 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index ae28b85..f09badb 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -822,29 +822,42 @@ void _hfi1_do_send(struct work_struct *work)
 void hfi1_do_send(struct rvt_qp *qp)
 {
 	struct hfi1_pkt_state ps;
+	struct hfi1_qp_priv *priv = qp->priv;
 	int (*make_req)(struct rvt_qp *qp);
 	unsigned long flags;
 	unsigned long timeout;
+	unsigned long timeout_int;
+	int cpu;
 
 	ps.dev = to_idev(qp->ibqp.device);
 	ps.ibp = to_iport(qp->ibqp.device, qp->port_num);
 	ps.ppd = ppd_from_ibp(ps.ibp);
 
-	if ((qp->ibqp.qp_type == IB_QPT_RC ||
-	     qp->ibqp.qp_type == IB_QPT_UC) &&
-	    !loopback &&
-	    (qp->remote_ah_attr.dlid & ~((1 << ps.ppd->lmc) - 1)) ==
-	    ps.ppd->lid) {
-		ruc_loopback(qp);
-		return;
-	}
-
-	if (qp->ibqp.qp_type == IB_QPT_RC)
+	switch (qp->ibqp.qp_type) {
+	case IB_QPT_RC:
+		if (!loopback && ((qp->remote_ah_attr.dlid & ~((1 << ps.ppd->lmc
+								) - 1)) ==
+				 ps.ppd->lid)) {
+			ruc_loopback(qp);
+			return;
+		}
 		make_req = hfi1_make_rc_req;
-	else if (qp->ibqp.qp_type == IB_QPT_UC)
+		timeout_int = (qp->timeout_jiffies);
+		break;
+	case IB_QPT_UC:
+		if (!loopback && ((qp->remote_ah_attr.dlid & ~((1 << ps.ppd->lmc
+								) - 1)) ==
+				 ps.ppd->lid)) {
+			ruc_loopback(qp);
+			return;
+		}
 		make_req = hfi1_make_uc_req;
-	else
+		timeout_int = SEND_RESCHED_TIMEOUT;
+		break;
+	default:
 		make_req = hfi1_make_ud_req;
+		timeout_int = SEND_RESCHED_TIMEOUT;
+	}
 
 	spin_lock_irqsave(&qp->s_lock, flags);
 
@@ -858,7 +871,9 @@ void hfi1_do_send(struct rvt_qp *qp)
 
 	spin_unlock_irqrestore(&qp->s_lock, flags);
 
-	timeout = jiffies + SEND_RESCHED_TIMEOUT;
+	timeout = jiffies + (timeout_int) / 8;
+	cpu = priv->s_sde ? priv->s_sde->cpu :
+			cpumask_first(cpumask_of_node(ps.ppd->dd->node));
 	do {
 		/* Check for a constructed packet to be sent. */
 		if (qp->s_hdrwords != 0) {
@@ -874,9 +889,18 @@ void hfi1_do_send(struct rvt_qp *qp)
 
 		/* allow other tasks to run */
 		if (unlikely(time_after(jiffies, timeout))) {
+			if (workqueue_congested(cpu, ps.ppd->hfi1_wq)) {
+				spin_lock_irqsave(&qp->s_lock, flags);
+				qp->s_flags &= ~RVT_S_BUSY;
+				hfi1_schedule_send(qp);
+				spin_unlock_irqrestore(&qp->s_lock,
+						       flags);
+				this_cpu_inc(*ps.ppd->dd->send_schedule);
+				return;
+			}
 			cond_resched();
 			this_cpu_inc(*ps.ppd->dd->send_schedule);
-			timeout = jiffies + SEND_RESCHED_TIMEOUT;
+			timeout = jiffies + (timeout_int) / 8;
 		}
 	} while (make_req(qp));
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
