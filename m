From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH rdma-rc] iw_cxgb4: only clear the ARMED bit if a notification
 is needed
Date: Thu, 30 Nov 2017 09:41:56 -0800
Message-ID: <20171201213130.1ED79E0C84@smtp.ogc.us>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In __flush_qp(), the CQ ARMED bit was being cleared regardless of
whether any notification is actually needed.  This resulted in the iser
termination logic getting stuck in ib_drain_sq() because the CQ was not
marked ARMED and thus the drain CQE notification wasn't triggered.

This new bug was exposed when this commit was merged:

commit cbb40fadd31c ("iw_cxgb4: only call the cq comp_handler when the
cq is armed")

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/qp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 5ee7fe4..355e288 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1285,21 +1285,21 @@ static void __flush_qp(struct c4iw_qp *qhp, struct c4iw_cq *rchp,
 	spin_unlock_irqrestore(&rchp->lock, flag);
 
 	if (schp == rchp) {
-		if (t4_clear_cq_armed(&rchp->cq) &&
-		    (rq_flushed || sq_flushed)) {
+		if ((rq_flushed || sq_flushed) &&
+		    t4_clear_cq_armed(&rchp->cq)) {
 			spin_lock_irqsave(&rchp->comp_handler_lock, flag);
 			(*rchp->ibcq.comp_handler)(&rchp->ibcq,
 						   rchp->ibcq.cq_context);
 			spin_unlock_irqrestore(&rchp->comp_handler_lock, flag);
 		}
 	} else {
-		if (t4_clear_cq_armed(&rchp->cq) && rq_flushed) {
+		if (rq_flushed && t4_clear_cq_armed(&rchp->cq)) {
 			spin_lock_irqsave(&rchp->comp_handler_lock, flag);
 			(*rchp->ibcq.comp_handler)(&rchp->ibcq,
 						   rchp->ibcq.cq_context);
 			spin_unlock_irqrestore(&rchp->comp_handler_lock, flag);
 		}
-		if (t4_clear_cq_armed(&schp->cq) && sq_flushed) {
+		if (sq_flushed && t4_clear_cq_armed(&schp->cq)) {
 			spin_lock_irqsave(&schp->comp_handler_lock, flag);
 			(*schp->ibcq.comp_handler)(&schp->ibcq,
 						   schp->ibcq.cq_context);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
