From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 3/3] iw_cxgb4: handing draining an idle qp
Date: Tue, 12 Apr 2016 06:55:03 -0700
Message-ID: <20160412143041.51965E08CA@smtp.ogc.us>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In c4iw_drain_sq/rq(), if the particular queue is already empty
then don't block.

Fixes: ce4af14d94aa ('iw_cxgb4: add queue drain functions')
Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/qp.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index e17fb5d5..8aa2e52 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1895,13 +1895,27 @@ int c4iw_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 void c4iw_drain_sq(struct ib_qp *ibqp)
 {
 	struct c4iw_qp *qp = to_c4iw_qp(ibqp);
+	unsigned long flag;
+	bool need_to_wait;
+
+	spin_lock_irqsave(&qp->lock, flag);
+	need_to_wait = !t4_sq_empty(&qp->wq);
+	spin_unlock_irqrestore(&qp->lock, flag);
 
-	wait_for_completion(&qp->sq_drained);
+	if (need_to_wait)
+		wait_for_completion(&qp->sq_drained);
 }
 
 void c4iw_drain_rq(struct ib_qp *ibqp)
 {
 	struct c4iw_qp *qp = to_c4iw_qp(ibqp);
+	unsigned long flag;
+	bool need_to_wait;
+
+	spin_lock_irqsave(&qp->lock, flag);
+	need_to_wait = !t4_rq_empty(&qp->wq);
+	spin_unlock_irqrestore(&qp->lock, flag);
 
-	wait_for_completion(&qp->rq_drained);
+	if (need_to_wait)
+		wait_for_completion(&qp->rq_drained);
 }
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
