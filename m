From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH rdma-rc] iw_cxgb4: only insert drain cqes if wq is flushed
Date: Mon, 27 Nov 2017 13:16:32 -0800
Message-ID: <20171206200809.AF14C87CA@linode.aoot.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Only insert our special drain CQEs to support ib_drain_sq/rq() after
the wq is flushed. Otherwise, existing but not yet polled CQEs can be
returned out of order to the user application.  This can happen when the
QP has exited RTS but not yet flushed the QP, which can happen during
a normal close (vs abortive close).

In addition never count the drain CQEs when determining how many CQEs
need to be synthesized during the flush operation.  This latter issue
should never happen if the QP is properly flushed before inserting the
drain CQE, but I wanted to avoid corrupting the CQ state.  So we handle
it and log a warning once.

Fixes: 4fe7c2962e11 ("iw_cxgb4: refactor sq/rq drain logic")
Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/infiniband/hw/cxgb4/cq.c |  5 +++++
 drivers/infiniband/hw/cxgb4/qp.c | 14 ++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index ea55e95cd2c5..b7bfc536e00f 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -395,6 +395,11 @@ void c4iw_flush_hw_cq(struct c4iw_cq *chp)
 
 static int cqe_completes_wr(struct t4_cqe *cqe, struct t4_wq *wq)
 {
+	if (CQE_OPCODE(cqe) == C4IW_DRAIN_OPCODE) {
+		WARN_ONCE(1, "Unexpected DRAIN CQE qp id %u!\n", wq->sq.qid);
+		return 0;
+	}
+
 	if (CQE_OPCODE(cqe) == FW_RI_TERMINATE)
 		return 0;
 
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 355e288ec969..38bddd02a943 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -868,7 +868,12 @@ int c4iw_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 
 	qhp = to_c4iw_qp(ibqp);
 	spin_lock_irqsave(&qhp->lock, flag);
-	if (t4_wq_in_error(&qhp->wq)) {
+
+	/*
+	 * If the qp has been flushed, then just insert a special
+	 * drain cqe.
+	 */
+	if (qhp->wq.flushed) {
 		spin_unlock_irqrestore(&qhp->lock, flag);
 		complete_sq_drain_wr(qhp, wr);
 		return err;
@@ -1011,7 +1016,12 @@ int c4iw_post_receive(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 
 	qhp = to_c4iw_qp(ibqp);
 	spin_lock_irqsave(&qhp->lock, flag);
-	if (t4_wq_in_error(&qhp->wq)) {
+
+	/*
+	 * If the qp has been flushed, then just insert a special
+	 * drain cqe.
+	 */
+	if (qhp->wq.flushed) {
 		spin_unlock_irqrestore(&qhp->lock, flag);
 		complete_rq_drain_wr(qhp, wr);
 		return err;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
