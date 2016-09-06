From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 02/13] IB/rdmavt, IB/qib,
 IB/hfi1: Use new QP put get routines
Date: Tue, 06 Sep 2016 04:34:35 -0700
Message-ID: <20160906113426.27413.51539.stgit@scvm10.sc.intel.com>
References: <20160906112758.27413.46860.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160906112758.27413.46860.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This improves readability and hides the reference count
mechanism from the client drivers.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/qp.c          |   11 ++++-------
 drivers/infiniband/hw/hfi1/rc.c          |    9 ++++-----
 drivers/infiniband/hw/hfi1/verbs.c       |    4 ++--
 drivers/infiniband/hw/hfi1/verbs_txreq.c |    2 +-
 drivers/infiniband/hw/qib/qib_driver.c   |    3 +--
 drivers/infiniband/hw/qib/qib_rc.c       |   12 ++++++------
 drivers/infiniband/sw/rdmavt/qp.c        |    5 ++---
 7 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index 4e4d831..63f56a8 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -202,8 +202,7 @@ static void flush_iowait(struct rvt_qp *qp)
 	write_seqlock_irqsave(&dev->iowait_lock, flags);
 	if (!list_empty(&priv->s_iowait.list)) {
 		list_del_init(&priv->s_iowait.list);
-		if (atomic_dec_and_test(&qp->refcount))
-			wake_up(&qp->wait);
+		rvt_put_qp(qp);
 	}
 	write_sequnlock_irqrestore(&dev->iowait_lock, flags);
 }
@@ -503,8 +502,7 @@ void hfi1_qp_wakeup(struct rvt_qp *qp, u32 flag)
 	}
 	spin_unlock_irqrestore(&qp->s_lock, flags);
 	/* Notify hfi1_destroy_qp() if it is waiting. */
-	if (atomic_dec_and_test(&qp->refcount))
-		wake_up(&qp->wait);
+	rvt_put_qp(qp);
 }
 
 static int iowait_sleep(
@@ -544,7 +542,7 @@ static int iowait_sleep(
 			qp->s_flags |= RVT_S_WAIT_DMA_DESC;
 			list_add_tail(&priv->s_iowait.list, &sde->dmawait);
 			trace_hfi1_qpsleep(qp, RVT_S_WAIT_DMA_DESC);
-			atomic_inc(&qp->refcount);
+			rvt_get_qp(qp);
 		}
 		write_sequnlock(&dev->iowait_lock);
 		qp->s_flags &= ~RVT_S_BUSY;
@@ -963,8 +961,7 @@ void notify_error_qp(struct rvt_qp *qp)
 	if (!list_empty(&priv->s_iowait.list) && !(qp->s_flags & RVT_S_BUSY)) {
 		qp->s_flags &= ~RVT_S_ANY_WAIT_IO;
 		list_del_init(&priv->s_iowait.list);
-		if (atomic_dec_and_test(&qp->refcount))
-			wake_up(&qp->wait);
+		rvt_put_qp(qp);
 	}
 	write_sequnlock(&dev->iowait_lock);
 
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 5da190e..acf0eb8 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -1389,7 +1389,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 				restart_rc(qp, qp->s_last_psn + 1, 0);
 				if (list_empty(&qp->rspwait)) {
 					qp->r_flags |= RVT_R_RSP_SEND;
-					atomic_inc(&qp->refcount);
+					rvt_get_qp(qp);
 					list_add_tail(&qp->rspwait,
 						      &rcd->qp_wait_list);
 				}
@@ -1573,7 +1573,7 @@ static void rdma_seq_err(struct rvt_qp *qp, struct hfi1_ibport *ibp, u32 psn,
 	restart_rc(qp, qp->s_last_psn + 1, 0);
 	if (list_empty(&qp->rspwait)) {
 		qp->r_flags |= RVT_R_RSP_SEND;
-		atomic_inc(&qp->refcount);
+		rvt_get_qp(qp);
 		list_add_tail(&qp->rspwait, &rcd->qp_wait_list);
 	}
 }
@@ -1782,7 +1782,7 @@ static inline void rc_defered_ack(struct hfi1_ctxtdata *rcd,
 {
 	if (list_empty(&qp->rspwait)) {
 		qp->r_flags |= RVT_R_RSP_NAK;
-		atomic_inc(&qp->refcount);
+		rvt_get_qp(qp);
 		list_add_tail(&qp->rspwait, &rcd->qp_wait_list);
 	}
 }
@@ -1796,8 +1796,7 @@ static inline void rc_cancel_ack(struct rvt_qp *qp)
 		return;
 	list_del_init(&qp->rspwait);
 	qp->r_flags &= ~RVT_R_RSP_NAK;
-	if (atomic_dec_and_test(&qp->refcount))
-		wake_up(&qp->wait);
+	rvt_put_qp(qp);
 }
 
 /**
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 2b35954..92a61c4 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -748,7 +748,7 @@ static int wait_kmem(struct hfi1_ibdev *dev,
 			qp->s_flags |= RVT_S_WAIT_KMEM;
 			list_add_tail(&priv->s_iowait.list, &dev->memwait);
 			trace_hfi1_qpsleep(qp, RVT_S_WAIT_KMEM);
-			atomic_inc(&qp->refcount);
+			rvt_get_qp(qp);
 		}
 		write_sequnlock(&dev->iowait_lock);
 		qp->s_flags &= ~RVT_S_BUSY;
@@ -959,7 +959,7 @@ static int pio_wait(struct rvt_qp *qp,
 			was_empty = list_empty(&sc->piowait);
 			list_add_tail(&priv->s_iowait.list, &sc->piowait);
 			trace_hfi1_qpsleep(qp, RVT_S_WAIT_PIO);
-			atomic_inc(&qp->refcount);
+			rvt_get_qp(qp);
 			/* counting: only call wantpiobuf_intr if first user */
 			if (was_empty)
 				hfi1_sc_wantpiobuf_intr(sc, 1);
diff --git a/drivers/infiniband/hw/hfi1/verbs_txreq.c b/drivers/infiniband/hw/hfi1/verbs_txreq.c
index d8fb056..094ab82 100644
--- a/drivers/infiniband/hw/hfi1/verbs_txreq.c
+++ b/drivers/infiniband/hw/hfi1/verbs_txreq.c
@@ -109,7 +109,7 @@ struct verbs_txreq *__get_txreq(struct hfi1_ibdev *dev,
 			qp->s_flags |= RVT_S_WAIT_TX;
 			list_add_tail(&priv->s_iowait.list, &dev->txwait);
 			trace_hfi1_qpsleep(qp, RVT_S_WAIT_TX);
-			atomic_inc(&qp->refcount);
+			rvt_get_qp(qp);
 		}
 		qp->s_flags &= ~RVT_S_BUSY;
 	}
diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index 67ee643..df77d5f 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -588,8 +588,7 @@ move_along:
 				qib_schedule_send(qp);
 			spin_unlock_irqrestore(&qp->s_lock, flags);
 		}
-		if (atomic_dec_and_test(&qp->refcount))
-			wake_up(&qp->wait);
+		rvt_put_qp(qp);
 	}
 
 bail:
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 444028a..38cd871 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -1177,7 +1177,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 				qib_restart_rc(qp, qp->s_last_psn + 1, 0);
 				if (list_empty(&qp->rspwait)) {
 					qp->r_flags |= RVT_R_RSP_SEND;
-					atomic_inc(&qp->refcount);
+					rvt_get_qp(qp);
 					list_add_tail(&qp->rspwait,
 						      &rcd->qp_wait_list);
 				}
@@ -1361,7 +1361,7 @@ static void rdma_seq_err(struct rvt_qp *qp, struct qib_ibport *ibp, u32 psn,
 	qib_restart_rc(qp, qp->s_last_psn + 1, 0);
 	if (list_empty(&qp->rspwait)) {
 		qp->r_flags |= RVT_R_RSP_SEND;
-		atomic_inc(&qp->refcount);
+		rvt_get_qp(qp);
 		list_add_tail(&qp->rspwait, &rcd->qp_wait_list);
 	}
 }
@@ -1640,7 +1640,7 @@ static int qib_rc_rcv_error(struct qib_other_headers *ohdr,
 			 */
 			if (list_empty(&qp->rspwait)) {
 				qp->r_flags |= RVT_R_RSP_NAK;
-				atomic_inc(&qp->refcount);
+				rvt_get_qp(qp);
 				list_add_tail(&qp->rspwait, &rcd->qp_wait_list);
 			}
 		}
@@ -2233,7 +2233,7 @@ rnr_nak:
 	/* Queue RNR NAK for later */
 	if (list_empty(&qp->rspwait)) {
 		qp->r_flags |= RVT_R_RSP_NAK;
-		atomic_inc(&qp->refcount);
+		rvt_get_qp(qp);
 		list_add_tail(&qp->rspwait, &rcd->qp_wait_list);
 	}
 	return;
@@ -2245,7 +2245,7 @@ nack_op_err:
 	/* Queue NAK for later */
 	if (list_empty(&qp->rspwait)) {
 		qp->r_flags |= RVT_R_RSP_NAK;
-		atomic_inc(&qp->refcount);
+		rvt_get_qp(qp);
 		list_add_tail(&qp->rspwait, &rcd->qp_wait_list);
 	}
 	return;
@@ -2259,7 +2259,7 @@ nack_inv:
 	/* Queue NAK for later */
 	if (list_empty(&qp->rspwait)) {
 		qp->r_flags |= RVT_R_RSP_NAK;
-		atomic_inc(&qp->refcount);
+		rvt_get_qp(qp);
 		list_add_tail(&qp->rspwait, &rcd->qp_wait_list);
 	}
 	return;
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 870b4f2..da5c8d6 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -488,8 +488,7 @@ static void rvt_remove_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp)
 	spin_unlock_irqrestore(&rdi->qp_dev->qpt_lock, flags);
 	if (removed) {
 		synchronize_rcu();
-		if (atomic_dec_and_test(&qp->refcount))
-			wake_up(&qp->wait);
+		rvt_put_qp(qp);
 	}
 }
 
@@ -980,7 +979,7 @@ static void rvt_insert_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp)
 	struct rvt_ibport *rvp = rdi->ports[qp->port_num - 1];
 	unsigned long flags;
 
-	atomic_inc(&qp->refcount);
+	rvt_get_qp(qp);
 	spin_lock_irqsave(&rdi->qp_dev->qpt_lock, flags);
 
 	if (qp->ibqp.qp_num <= 1) {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
