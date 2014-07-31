From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] iw_cxgb4: Only call the cq completion handler if it is armed
Date: Thu, 31 Jul 2014 14:35:43 -0500
Message-ID: <20140731193543.11837.6982.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Function __flush_qp() always calls the ULP's CQ completion handler
functions even if the CQ was not armed.  This can crash the system if the
function pointer is NULL. The iSER ULP behaves this way: no completion
handler and never arm the CQ for notification.  So now we track whether
the CQ is armed at flush time and only call the completion handlers if
their CQs were armed.

Also, if the RCQ and SCQ are the same CQ, the completion handler is
getting called twice.  It should only be called once after all SQ and
RQ WRs are flushed from the QP.  So rearrange the logic to fix this.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/ev.c |    1 +
 drivers/infiniband/hw/cxgb4/qp.c |   37 +++++++++++++++++++++++++------------
 drivers/infiniband/hw/cxgb4/t4.h |   11 +++++++++++
 3 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/ev.c b/drivers/infiniband/hw/cxgb4/ev.c
index d61d0a1..a98426f 100644
--- a/drivers/infiniband/hw/cxgb4/ev.c
+++ b/drivers/infiniband/hw/cxgb4/ev.c
@@ -182,6 +182,7 @@ int c4iw_ev_handler(struct c4iw_dev *dev, u32 qid)
 
 	chp = get_chp(dev, qid);
 	if (chp) {
+		t4_clear_cq_armed(&chp->cq);
 		spin_lock_irqsave(&chp->comp_handler_lock, flag);
 		(*chp->ibcq.comp_handler)(&chp->ibcq, chp->ibcq.cq_context);
 		spin_unlock_irqrestore(&chp->comp_handler_lock, flag);
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 086f62f..60cfc11 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1066,7 +1066,7 @@ static void __flush_qp(struct c4iw_qp *qhp, struct c4iw_cq *rchp,
 		       struct c4iw_cq *schp)
 {
 	int count;
-	int flushed;
+	int rq_flushed, sq_flushed;
 	unsigned long flag;
 
 	PDBG("%s qhp %p rchp %p schp %p\n", __func__, qhp, rchp, schp);
@@ -1084,27 +1084,40 @@ static void __flush_qp(struct c4iw_qp *qhp, struct c4iw_cq *rchp,
 
 	c4iw_flush_hw_cq(rchp);
 	c4iw_count_rcqes(&rchp->cq, &qhp->wq, &count);
-	flushed = c4iw_flush_rq(&qhp->wq, &rchp->cq, count);
+	rq_flushed = c4iw_flush_rq(&qhp->wq, &rchp->cq, count);
 	spin_unlock(&qhp->lock);
 	spin_unlock_irqrestore(&rchp->lock, flag);
-	if (flushed) {
-		spin_lock_irqsave(&rchp->comp_handler_lock, flag);
-		(*rchp->ibcq.comp_handler)(&rchp->ibcq, rchp->ibcq.cq_context);
-		spin_unlock_irqrestore(&rchp->comp_handler_lock, flag);
-	}
 
 	/* locking hierarchy: cq lock first, then qp lock. */
 	spin_lock_irqsave(&schp->lock, flag);
 	spin_lock(&qhp->lock);
 	if (schp != rchp)
 		c4iw_flush_hw_cq(schp);
-	flushed = c4iw_flush_sq(qhp);
+	sq_flushed = c4iw_flush_sq(qhp);
 	spin_unlock(&qhp->lock);
 	spin_unlock_irqrestore(&schp->lock, flag);
-	if (flushed) {
-		spin_lock_irqsave(&schp->comp_handler_lock, flag);
-		(*schp->ibcq.comp_handler)(&schp->ibcq, schp->ibcq.cq_context);
-		spin_unlock_irqrestore(&schp->comp_handler_lock, flag);
+
+	if (schp == rchp) {
+		if (t4_clear_cq_armed(&rchp->cq) &&
+		    (rq_flushed || sq_flushed)) {
+			spin_lock_irqsave(&rchp->comp_handler_lock, flag);
+			(*rchp->ibcq.comp_handler)(&rchp->ibcq,
+						   rchp->ibcq.cq_context);
+			spin_unlock_irqrestore(&rchp->comp_handler_lock, flag);
+		}
+	} else {
+		if (t4_clear_cq_armed(&rchp->cq) && rq_flushed) {
+			spin_lock_irqsave(&rchp->comp_handler_lock, flag);
+			(*rchp->ibcq.comp_handler)(&rchp->ibcq,
+						   rchp->ibcq.cq_context);
+			spin_unlock_irqrestore(&rchp->comp_handler_lock, flag);
+		}
+		if (t4_clear_cq_armed(&schp->cq) && sq_flushed) {
+			spin_lock_irqsave(&schp->comp_handler_lock, flag);
+			(*schp->ibcq.comp_handler)(&schp->ibcq,
+						   schp->ibcq.cq_context);
+			spin_unlock_irqrestore(&schp->comp_handler_lock, flag);
+		}
 	}
 }
 
diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
index 68b0a6b..d8d7fa3 100644
--- a/drivers/infiniband/hw/cxgb4/t4.h
+++ b/drivers/infiniband/hw/cxgb4/t4.h
@@ -531,6 +531,10 @@ static inline int t4_wq_db_enabled(struct t4_wq *wq)
 	return !wq->rq.queue[wq->rq.size].status.db_off;
 }
 
+enum t4_cq_flags {
+	CQ_ARMED	= 1,
+};
+
 struct t4_cq {
 	struct t4_cqe *queue;
 	dma_addr_t dma_addr;
@@ -551,12 +555,19 @@ struct t4_cq {
 	u16 cidx_inc;
 	u8 gen;
 	u8 error;
+	unsigned long flags;
 };
 
+static inline int t4_clear_cq_armed(struct t4_cq *cq)
+{
+	return test_and_clear_bit(CQ_ARMED, &cq->flags);
+}
+
 static inline int t4_arm_cq(struct t4_cq *cq, int se)
 {
 	u32 val;
 
+	set_bit(CQ_ARMED, &cq->flags);
 	while (cq->cidx_inc > CIDXINC_MASK) {
 		val = SEINTARM(0) | CIDXINC(CIDXINC_MASK) | TIMERREG(7) |
 		      INGRESSQID(cq->cqid);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
