From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/12] IB/qib, IB/hfi1: Fix up UD loopback use of irq flags
Date: Tue, 12 Apr 2016 10:46:10 -0700
Message-ID: <20160412174609.19295.88803.stgit@scvm10.sc.intel.com>
References: <20160412173504.19295.7241.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160412173504.19295.7241.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The dual lock patch moved locking around and missed an issue
with handling irq flags when processing UD loopback
packets.  This issue was revealed by smatch.

Fix for both qib and hfi1 to pass the saved flags to the UD request
builder and handle the changes correctly.

Fixes: 46a80d62e6e0 ("IB/qib, staging/rdma/hfi1: add s_hlock for use in post send")
Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_rc.c    |    2 +-
 drivers/infiniband/hw/qib/qib_ruc.c   |    4 ++--
 drivers/infiniband/hw/qib/qib_uc.c    |    2 +-
 drivers/infiniband/hw/qib/qib_ud.c    |   10 +++++-----
 drivers/infiniband/hw/qib/qib_verbs.h |    6 +++---
 drivers/staging/rdma/hfi1/ruc.c       |   20 +++++++++++---------
 drivers/staging/rdma/hfi1/ud.c        |    8 ++++----
 drivers/staging/rdma/hfi1/verbs.h     |    1 +
 8 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 9088e26..444028a 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -230,7 +230,7 @@ bail:
  *
  * Return 1 if constructed; otherwise, return 0.
  */
-int qib_make_rc_req(struct rvt_qp *qp)
+int qib_make_rc_req(struct rvt_qp *qp, unsigned long *flags)
 {
 	struct qib_qp_priv *priv = qp->priv;
 	struct qib_ibdev *dev = to_idev(qp->ibqp.device);
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index a5f07a6..b677792 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -739,7 +739,7 @@ void qib_do_send(struct rvt_qp *qp)
 	struct qib_qp_priv *priv = qp->priv;
 	struct qib_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
 	struct qib_pportdata *ppd = ppd_from_ibp(ibp);
-	int (*make_req)(struct rvt_qp *qp);
+	int (*make_req)(struct rvt_qp *qp, unsigned long *flags);
 	unsigned long flags;
 
 	if ((qp->ibqp.qp_type == IB_QPT_RC ||
@@ -781,7 +781,7 @@ void qib_do_send(struct rvt_qp *qp)
 			qp->s_hdrwords = 0;
 			spin_lock_irqsave(&qp->s_lock, flags);
 		}
-	} while (make_req(qp));
+	} while (make_req(qp, &flags));
 
 	spin_unlock_irqrestore(&qp->s_lock, flags);
 }
diff --git a/drivers/infiniband/hw/qib/qib_uc.c b/drivers/infiniband/hw/qib/qib_uc.c
index 7bdbc79..1d61bd0 100644
--- a/drivers/infiniband/hw/qib/qib_uc.c
+++ b/drivers/infiniband/hw/qib/qib_uc.c
@@ -45,7 +45,7 @@
  *
  * Return 1 if constructed; otherwise, return 0.
  */
-int qib_make_uc_req(struct rvt_qp *qp)
+int qib_make_uc_req(struct rvt_qp *qp, unsigned long *flags)
 {
 	struct qib_qp_priv *priv = qp->priv;
 	struct qib_other_headers *ohdr;
diff --git a/drivers/infiniband/hw/qib/qib_ud.c b/drivers/infiniband/hw/qib/qib_ud.c
index d950213..846e6c7 100644
--- a/drivers/infiniband/hw/qib/qib_ud.c
+++ b/drivers/infiniband/hw/qib/qib_ud.c
@@ -238,7 +238,7 @@ drop:
  *
  * Return 1 if constructed; otherwise, return 0.
  */
-int qib_make_ud_req(struct rvt_qp *qp)
+int qib_make_ud_req(struct rvt_qp *qp, unsigned long *flags)
 {
 	struct qib_qp_priv *priv = qp->priv;
 	struct qib_other_headers *ohdr;
@@ -294,7 +294,7 @@ int qib_make_ud_req(struct rvt_qp *qp)
 		this_cpu_inc(ibp->pmastats->n_unicast_xmit);
 		lid = ah_attr->dlid & ~((1 << ppd->lmc) - 1);
 		if (unlikely(lid == ppd->lid)) {
-			unsigned long flags;
+			unsigned long tflags = *flags;
 			/*
 			 * If DMAs are in progress, we can't generate
 			 * a completion for the loopback packet since
@@ -307,10 +307,10 @@ int qib_make_ud_req(struct rvt_qp *qp)
 				goto bail;
 			}
 			qp->s_cur = next_cur;
-			local_irq_save(flags);
-			spin_unlock_irqrestore(&qp->s_lock, flags);
+			spin_unlock_irqrestore(&qp->s_lock, tflags);
 			qib_ud_loopback(qp, wqe);
-			spin_lock_irqsave(&qp->s_lock, flags);
+			spin_lock_irqsave(&qp->s_lock, tflags);
+			*flags = tflags;
 			qib_send_complete(qp, wqe, IB_WC_SUCCESS);
 			goto done;
 		}
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 4b76a8d..6888f03 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -430,11 +430,11 @@ void qib_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 
 void qib_send_rc_ack(struct rvt_qp *qp);
 
-int qib_make_rc_req(struct rvt_qp *qp);
+int qib_make_rc_req(struct rvt_qp *qp, unsigned long *flags);
 
-int qib_make_uc_req(struct rvt_qp *qp);
+int qib_make_uc_req(struct rvt_qp *qp, unsigned long *flags);
 
-int qib_make_ud_req(struct rvt_qp *qp);
+int qib_make_ud_req(struct rvt_qp *qp, unsigned long *flags);
 
 int qib_register_ib_device(struct qib_devdata *);
 
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index 08813cd..a659aec 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -831,7 +831,6 @@ void hfi1_do_send(struct rvt_qp *qp)
 	struct hfi1_pkt_state ps;
 	struct hfi1_qp_priv *priv = qp->priv;
 	int (*make_req)(struct rvt_qp *qp, struct hfi1_pkt_state *ps);
-	unsigned long flags;
 	unsigned long timeout;
 	unsigned long timeout_int;
 	int cpu;
@@ -866,11 +865,11 @@ void hfi1_do_send(struct rvt_qp *qp)
 		timeout_int = SEND_RESCHED_TIMEOUT;
 	}
 
-	spin_lock_irqsave(&qp->s_lock, flags);
+	spin_lock_irqsave(&qp->s_lock, ps.flags);
 
 	/* Return if we are already busy processing a work request. */
 	if (!hfi1_send_ok(qp)) {
-		spin_unlock_irqrestore(&qp->s_lock, flags);
+		spin_unlock_irqrestore(&qp->s_lock, ps.flags);
 		return;
 	}
 
@@ -884,7 +883,7 @@ void hfi1_do_send(struct rvt_qp *qp)
 	do {
 		/* Check for a constructed packet to be sent. */
 		if (qp->s_hdrwords != 0) {
-			spin_unlock_irqrestore(&qp->s_lock, flags);
+			spin_unlock_irqrestore(&qp->s_lock, ps.flags);
 			/*
 			 * If the packet cannot be sent now, return and
 			 * the send tasklet will be woken up later.
@@ -897,11 +896,14 @@ void hfi1_do_send(struct rvt_qp *qp)
 			if (unlikely(time_after(jiffies, timeout))) {
 				if (workqueue_congested(cpu,
 							ps.ppd->hfi1_wq)) {
-					spin_lock_irqsave(&qp->s_lock, flags);
+					spin_lock_irqsave(
+						&qp->s_lock,
+						ps.flags);
 					qp->s_flags &= ~RVT_S_BUSY;
 					hfi1_schedule_send(qp);
-					spin_unlock_irqrestore(&qp->s_lock,
-							       flags);
+					spin_unlock_irqrestore(
+						&qp->s_lock,
+						ps.flags);
 					this_cpu_inc(
 						*ps.ppd->dd->send_schedule);
 					return;
@@ -913,11 +915,11 @@ void hfi1_do_send(struct rvt_qp *qp)
 				}
 				timeout = jiffies + (timeout_int) / 8;
 			}
-			spin_lock_irqsave(&qp->s_lock, flags);
+			spin_lock_irqsave(&qp->s_lock, ps.flags);
 		}
 	} while (make_req(qp, &ps));
 
-	spin_unlock_irqrestore(&qp->s_lock, flags);
+	spin_unlock_irqrestore(&qp->s_lock, ps.flags);
 }
 
 /*
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index ae8a70f..1e503ad 100644
--- a/drivers/staging/rdma/hfi1/ud.c
+++ b/drivers/staging/rdma/hfi1/ud.c
@@ -322,7 +322,7 @@ int hfi1_make_ud_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 			     (lid == ppd->lid ||
 			      (lid == be16_to_cpu(IB_LID_PERMISSIVE) &&
 			      qp->ibqp.qp_type == IB_QPT_GSI)))) {
-			unsigned long flags;
+			unsigned long tflags = ps->flags;
 			/*
 			 * If DMAs are in progress, we can't generate
 			 * a completion for the loopback packet since
@@ -335,10 +335,10 @@ int hfi1_make_ud_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 				goto bail;
 			}
 			qp->s_cur = next_cur;
-			local_irq_save(flags);
-			spin_unlock_irqrestore(&qp->s_lock, flags);
+			spin_unlock_irqrestore(&qp->s_lock, tflags);
 			ud_loopback(qp, wqe);
-			spin_lock_irqsave(&qp->s_lock, flags);
+			spin_lock_irqsave(&qp->s_lock, tflags);
+			ps->flags = tflags;
 			hfi1_send_complete(qp, wqe, IB_WC_SUCCESS);
 			goto done_free_tx;
 		}
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index 6c4670f..2ba1373 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -215,6 +215,7 @@ struct hfi1_pkt_state {
 	struct hfi1_ibport *ibp;
 	struct hfi1_pportdata *ppd;
 	struct verbs_txreq *s_txreq;
+	unsigned long flags;
 };
 
 #define HFI1_PSN_CREDIT  16

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
