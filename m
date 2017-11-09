From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 1/2] iw_cxgb4: only call the cq comp_handler when the cq is
 armed
Date: Thu, 9 Nov 2017 07:14:43 -0800
Message-ID: <20171110182301.0122F8760@linode.aoot.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The ULPs completion handler should only be called if the CQ is
armed for notification.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/ev.c |  8 +++++---
 drivers/infiniband/hw/cxgb4/qp.c | 20 ++++++++++++--------
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/ev.c b/drivers/infiniband/hw/cxgb4/ev.c
index b8c7cc9..a252d5c 100644
--- a/drivers/infiniband/hw/cxgb4/ev.c
+++ b/drivers/infiniband/hw/cxgb4/ev.c
@@ -109,9 +109,11 @@ static void post_qp_event(struct c4iw_dev *dev, struct c4iw_cq *chp,
 	if (qhp->ibqp.event_handler)
 		(*qhp->ibqp.event_handler)(&event, qhp->ibqp.qp_context);
 
-	spin_lock_irqsave(&chp->comp_handler_lock, flag);
-	(*chp->ibcq.comp_handler)(&chp->ibcq, chp->ibcq.cq_context);
-	spin_unlock_irqrestore(&chp->comp_handler_lock, flag);
+	if (t4_clear_cq_armed(&chp->cq)) {
+		spin_lock_irqsave(&chp->comp_handler_lock, flag);
+		(*chp->ibcq.comp_handler)(&chp->ibcq, chp->ibcq.cq_context);
+		spin_unlock_irqrestore(&chp->comp_handler_lock, flag);
+	}
 }
 
 void c4iw_ev_dispatch(struct c4iw_dev *dev, struct t4_cqe *err_cqe)
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 86d6550..1f6210b 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -813,10 +813,12 @@ static void complete_sq_drain_wr(struct c4iw_qp *qhp, struct ib_send_wr *wr)
 	t4_swcq_produce(cq);
 	spin_unlock_irqrestore(&schp->lock, flag);
 
-	spin_lock_irqsave(&schp->comp_handler_lock, flag);
-	(*schp->ibcq.comp_handler)(&schp->ibcq,
-				   schp->ibcq.cq_context);
-	spin_unlock_irqrestore(&schp->comp_handler_lock, flag);
+	if (t4_clear_cq_armed(&schp->cq)) {
+		spin_lock_irqsave(&schp->comp_handler_lock, flag);
+		(*schp->ibcq.comp_handler)(&schp->ibcq,
+					   schp->ibcq.cq_context);
+		spin_unlock_irqrestore(&schp->comp_handler_lock, flag);
+	}
 }
 
 static void complete_rq_drain_wr(struct c4iw_qp *qhp, struct ib_recv_wr *wr)
@@ -842,10 +844,12 @@ static void complete_rq_drain_wr(struct c4iw_qp *qhp, struct ib_recv_wr *wr)
 	t4_swcq_produce(cq);
 	spin_unlock_irqrestore(&rchp->lock, flag);
 
-	spin_lock_irqsave(&rchp->comp_handler_lock, flag);
-	(*rchp->ibcq.comp_handler)(&rchp->ibcq,
-				   rchp->ibcq.cq_context);
-	spin_unlock_irqrestore(&rchp->comp_handler_lock, flag);
+	if (t4_clear_cq_armed(&rchp->cq)) {
+		spin_lock_irqsave(&rchp->comp_handler_lock, flag);
+		(*rchp->ibcq.comp_handler)(&rchp->ibcq,
+					   rchp->ibcq.cq_context);
+		spin_unlock_irqrestore(&rchp->comp_handler_lock, flag);
+	}
 }
 
 int c4iw_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
