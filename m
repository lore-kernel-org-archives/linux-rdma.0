From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2/2] iw_cxgb4: explicitly move the qp to ERROR state during
 flush
Date: Fri, 29 Jul 2016 08:38:46 -0700
Message-ID: <069a9546fefe1c38aeb5fa0c47c7d32340b7847c.1469824142.git.swise@opengridcomputing.com>
References: <cover.1469824142.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1469824142.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This forces the connection to abort if the application failed to
disconnect before flushing.  This is aligned with how the common
flush services work.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/qp.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index e8993e4..0d461f3 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1896,12 +1896,20 @@ int c4iw_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	return 0;
 }
 
+static void move_qp_to_err(struct c4iw_qp *qp)
+{
+	struct c4iw_qp_attributes attrs = { .next_state = C4IW_QP_STATE_ERROR };
+
+	(void)c4iw_modify_qp(qp->rhp, qp, C4IW_QP_ATTR_NEXT_STATE, &attrs, 1);
+}
+
 void c4iw_drain_sq(struct ib_qp *ibqp)
 {
 	struct c4iw_qp *qp = to_c4iw_qp(ibqp);
 	unsigned long flag;
 	bool need_to_wait;
 
+	move_qp_to_err(qp);
 	spin_lock_irqsave(&qp->lock, flag);
 	need_to_wait = !t4_sq_empty(&qp->wq);
 	spin_unlock_irqrestore(&qp->lock, flag);
@@ -1916,6 +1924,7 @@ void c4iw_drain_rq(struct ib_qp *ibqp)
 	unsigned long flag;
 	bool need_to_wait;
 
+	move_qp_to_err(qp);
 	spin_lock_irqsave(&qp->lock, flag);
 	need_to_wait = !t4_rq_empty(&qp->wq);
 	spin_unlock_irqrestore(&qp->lock, flag);
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
