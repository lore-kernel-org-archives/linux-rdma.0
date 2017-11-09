From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2/2] iw_cxgb4: atomically flush the qp
Date: Thu, 9 Nov 2017 07:21:26 -0800
Message-ID: <20171110182310.259318761@linode.aoot.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

__flush_qp() has a race condition where during the flush operation,
the qp lock is released allowing another thread to possibly post a WR,
which corrupts the queue state, possibly causing crashes.  The lock was
released to preserve the cq/qp locking hierarchy of cq first, then qp.
However releasing the qp lock is not necessary; both RQ and SQ CQ locks
can be acquired first, followed by the qp lock, and then the RQ and SQ
flushing can be done w/o unlocking.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/qp.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 1f6210b..20595c6 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1255,31 +1255,34 @@ static void __flush_qp(struct c4iw_qp *qhp, struct c4iw_cq *rchp,
 
 	pr_debug("qhp %p rchp %p schp %p\n", qhp, rchp, schp);
 
-	/* locking hierarchy: cq lock first, then qp lock. */
+	/* locking hierarchy: cqs lock first, then qp lock. */
 	spin_lock_irqsave(&rchp->lock, flag);
+	if (schp != rchp)
+		spin_lock(&schp->lock);
 	spin_lock(&qhp->lock);
 
 	if (qhp->wq.flushed) {
 		spin_unlock(&qhp->lock);
+		if (schp != rchp)
+			spin_unlock(&schp->lock);
 		spin_unlock_irqrestore(&rchp->lock, flag);
 		return;
 	}
 	qhp->wq.flushed = 1;
+	t4_set_wq_in_error(&qhp->wq);
 
 	c4iw_flush_hw_cq(rchp);
 	c4iw_count_rcqes(&rchp->cq, &qhp->wq, &count);
 	rq_flushed = c4iw_flush_rq(&qhp->wq, &rchp->cq, count);
-	spin_unlock(&qhp->lock);
-	spin_unlock_irqrestore(&rchp->lock, flag);
 
-	/* locking hierarchy: cq lock first, then qp lock. */
-	spin_lock_irqsave(&schp->lock, flag);
-	spin_lock(&qhp->lock);
 	if (schp != rchp)
 		c4iw_flush_hw_cq(schp);
 	sq_flushed = c4iw_flush_sq(qhp);
+
 	spin_unlock(&qhp->lock);
-	spin_unlock_irqrestore(&schp->lock, flag);
+	if (schp != rchp)
+		spin_unlock(&schp->lock);
+	spin_unlock_irqrestore(&rchp->lock, flag);
 
 	if (schp == rchp) {
 		if (t4_clear_cq_armed(&rchp->cq) &&
@@ -1313,8 +1316,8 @@ static void flush_qp(struct c4iw_qp *qhp)
 	rchp = to_c4iw_cq(qhp->ibqp.recv_cq);
 	schp = to_c4iw_cq(qhp->ibqp.send_cq);
 
-	t4_set_wq_in_error(&qhp->wq);
 	if (qhp->ibqp.uobject) {
+		t4_set_wq_in_error(&qhp->wq);
 		t4_set_cq_in_error(&rchp->cq);
 		spin_lock_irqsave(&rchp->comp_handler_lock, flag);
 		(*rchp->ibcq.comp_handler)(&rchp->ibcq, rchp->ibcq.cq_context);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
