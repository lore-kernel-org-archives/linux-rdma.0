From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: Optimize locking for get_txreq()
Date: Fri, 23 Dec 2011 08:03:41 -0500
Message-ID: <20111223130341.31822.22643.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The current code locks the QP s_lock, followed by the pending_lock, I guess
to to protect against the allocate failing.

This patch only locks the pending_lock, assuming that the empty case is an
exeception, in which case the pending_lock is dropped, and the original code is
executed.  This will save a lock of s_lock in the normal case.

The observation is that the sdma descriptors will deplete at twice the rate of
txreq's, so this should be rare.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_verbs.c |   43 +++++++++++++++++++++++++--------
 1 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index a894762..7b6c3bf 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -913,8 +913,8 @@ static void copy_io(u32 __iomem *piobuf, struct qib_sge_state *ss,
 		__raw_writel(last, piobuf);
 }
 
-static struct qib_verbs_txreq *get_txreq(struct qib_ibdev *dev,
-					 struct qib_qp *qp, int *retp)
+static noinline struct qib_verbs_txreq *__get_txreq(struct qib_ibdev *dev,
+					   struct qib_qp *qp)
 {
 	struct qib_verbs_txreq *tx;
 	unsigned long flags;
@@ -926,8 +926,9 @@ static struct qib_verbs_txreq *get_txreq(struct qib_ibdev *dev,
 		struct list_head *l = dev->txreq_free.next;
 
 		list_del(l);
+		spin_unlock(&dev->pending_lock);
+		spin_unlock_irqrestore(&qp->s_lock, flags);
 		tx = list_entry(l, struct qib_verbs_txreq, txreq.list);
-		*retp = 0;
 	} else {
 		if (ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK &&
 		    list_empty(&qp->iowait)) {
@@ -935,14 +936,33 @@ static struct qib_verbs_txreq *get_txreq(struct qib_ibdev *dev,
 			qp->s_flags |= QIB_S_WAIT_TX;
 			list_add_tail(&qp->iowait, &dev->txwait);
 		}
-		tx = NULL;
 		qp->s_flags &= ~QIB_S_BUSY;
-		*retp = -EBUSY;
+		spin_unlock(&dev->pending_lock);
+		spin_unlock_irqrestore(&qp->s_lock, flags);
+		tx = ERR_PTR(-EBUSY);
 	}
+	return tx;
+}
 
-	spin_unlock(&dev->pending_lock);
-	spin_unlock_irqrestore(&qp->s_lock, flags);
+static inline struct qib_verbs_txreq *get_txreq(struct qib_ibdev *dev,
+					 struct qib_qp *qp)
+{
+	struct qib_verbs_txreq *tx;
+	unsigned long flags;
 
+	spin_lock_irqsave(&dev->pending_lock, flags);
+	/* assume the list non empty */
+	if (likely(!list_empty(&dev->txreq_free))) {
+		struct list_head *l = dev->txreq_free.next;
+
+		list_del(l);
+		spin_unlock_irqrestore(&dev->pending_lock, flags);
+		tx = list_entry(l, struct qib_verbs_txreq, txreq.list);
+	} else {
+		/* call slow path to get the extra lock */
+		spin_unlock_irqrestore(&dev->pending_lock, flags);
+		tx =  __get_txreq(dev, qp);
+	}
 	return tx;
 }
 
@@ -1122,9 +1142,9 @@ static int qib_verbs_send_dma(struct qib_qp *qp, struct qib_ib_header *hdr,
 		goto bail;
 	}
 
-	tx = get_txreq(dev, qp, &ret);
-	if (!tx)
-		goto bail;
+	tx = get_txreq(dev, qp);
+	if (IS_ERR(tx))
+		goto bail_tx;
 
 	control = dd->f_setpbc_control(ppd, plen, qp->s_srate,
 				       be16_to_cpu(hdr->lrh[0]) >> 12);
@@ -1195,6 +1215,9 @@ unaligned:
 	ibp->n_unaligned++;
 bail:
 	return ret;
+bail_tx:
+	ret = PTR_ERR(tx);
+	goto bail;
 }
 
 /*


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
