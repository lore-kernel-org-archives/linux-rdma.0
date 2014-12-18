From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 09/14] RDMA/ocrdma: Allow expansion of the SQ CQEs via buddy CQ expansion of the QP
Date: Thu, 18 Dec 2014 14:13:03 +0530
Message-ID: <5eba1530-efa8-47be-9dcb-42b0eddd9b1d@CMEXHTCAS1.ad.emulex.com>
References: <1418892188-6623-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418892188-6623-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

If the SQ and RQ of the QP in error state uses separate CQs, traverse the list
of QPs using each CQs and invoke the buddy CQ handler for both SQ and RQ.

Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c |   66 ++++++++++++++++++++----------
 1 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 8126c88..65b5923 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -834,20 +834,20 @@ static int ocrdma_mq_cq_handler(struct ocrdma_dev *dev, u16 cq_id)
 	return 0;
 }
 
-static void ocrdma_qp_buddy_cq_handler(struct ocrdma_dev *dev,
-				       struct ocrdma_cq *cq)
+static struct ocrdma_cq *_ocrdma_qp_buddy_cq_handler(struct ocrdma_dev *dev,
+				struct ocrdma_cq *cq, bool sq)
 {
-	unsigned long flags;
 	struct ocrdma_qp *qp;
-	bool buddy_cq_found = false;
-	/* Go through list of QPs in error state which are using this CQ
-	 * and invoke its callback handler to trigger CQE processing for
-	 * error/flushed CQE. It is rare to find more than few entries in
-	 * this list as most consumers stops after getting error CQE.
-	 * List is traversed only once when a matching buddy cq found for a QP.
-	 */
-	spin_lock_irqsave(&dev->flush_q_lock, flags);
-	list_for_each_entry(qp, &cq->sq_head, sq_entry) {
+	struct list_head *cur;
+	struct ocrdma_cq *bcq = NULL;
+	struct list_head *head = sq?(&cq->sq_head):(&cq->rq_head);
+
+	list_for_each(cur, head) {
+		if (sq)
+			qp = list_entry(cur, struct ocrdma_qp, sq_entry);
+		else
+			qp = list_entry(cur, struct ocrdma_qp, rq_entry);
+
 		if (qp->srq)
 			continue;
 		/* if wq and rq share the same cq, than comp_handler
@@ -859,19 +859,41 @@ static void ocrdma_qp_buddy_cq_handler(struct ocrdma_dev *dev,
 		 * if completion came on rq, sq's cq is buddy cq.
 		 */
 		if (qp->sq_cq == cq)
-			cq = qp->rq_cq;
+			bcq = qp->rq_cq;
 		else
-			cq = qp->sq_cq;
-		buddy_cq_found = true;
-		break;
+			bcq = qp->sq_cq;
+		return bcq;
 	}
+	return NULL;
+}
+
+static void ocrdma_qp_buddy_cq_handler(struct ocrdma_dev *dev,
+				       struct ocrdma_cq *cq)
+{
+	unsigned long flags;
+	struct ocrdma_cq *bcq = NULL;
+
+	/* Go through list of QPs in error state which are using this CQ
+	 * and invoke its callback handler to trigger CQE processing for
+	 * error/flushed CQE. It is rare to find more than few entries in
+	 * this list as most consumers stops after getting error CQE.
+	 * List is traversed only once when a matching buddy cq found for a QP.
+	 */
+	spin_lock_irqsave(&dev->flush_q_lock, flags);
+	/* Check if buddy CQ is present.
+	 * true - Check for  SQ CQ
+	 * false - Check for RQ CQ
+	 */
+	bcq = _ocrdma_qp_buddy_cq_handler(dev, cq, true);
+	if (bcq == NULL)
+		bcq = _ocrdma_qp_buddy_cq_handler(dev, cq, false);
 	spin_unlock_irqrestore(&dev->flush_q_lock, flags);
-	if (buddy_cq_found == false)
-		return;
-	if (cq->ibcq.comp_handler) {
-		spin_lock_irqsave(&cq->comp_handler_lock, flags);
-		(*cq->ibcq.comp_handler) (&cq->ibcq, cq->ibcq.cq_context);
-		spin_unlock_irqrestore(&cq->comp_handler_lock, flags);
+
+	/* if there is valid buddy cq, look for its completion handler */
+	if (bcq && bcq->ibcq.comp_handler) {
+		spin_lock_irqsave(&bcq->comp_handler_lock, flags);
+		(*bcq->ibcq.comp_handler) (&bcq->ibcq, bcq->ibcq.cq_context);
+		spin_unlock_irqrestore(&bcq->comp_handler_lock, flags);
 	}
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
