From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH rdma-rc 3/3] iw_cxgb4: when flushing, complete all wrs in a
 chain
Date: Tue, 19 Dec 2017 14:02:10 -0800
Message-ID: <20171220191654.E18282BC88@smtp.opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If a wr chain was posted and needed to be flushed, only the first
wr in the chain was completed with FLUSHED status.  The rest were
never completed.  This caused isert to hang on shutdown due to the
missing completions which left iscsi IO commands referenced, stalling
the shutdown.

Fixes: 4fe7c2962e11 ("iw_cxgb4: refactor sq/rq drain logic")

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/qp.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 21495f9..d5c92fc 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -858,6 +858,22 @@ static int complete_sq_drain_wr(struct c4iw_qp *qhp, struct ib_send_wr *wr)
 	return 0;
 }
 
+static int complete_sq_drain_wrs(struct c4iw_qp *qhp, struct ib_send_wr *wr,
+				struct ib_send_wr **bad_wr)
+{
+	int ret = 0;
+
+	while (wr) {
+		ret = complete_sq_drain_wr(qhp, wr);
+		if (ret) {
+			*bad_wr = wr;
+			break;
+		}
+		wr = wr->next;
+	}
+	return ret;
+}
+
 static void complete_rq_drain_wr(struct c4iw_qp *qhp, struct ib_recv_wr *wr)
 {
 	struct t4_cqe cqe = {};
@@ -890,6 +906,14 @@ static void complete_rq_drain_wr(struct c4iw_qp *qhp, struct ib_recv_wr *wr)
 	}
 }
 
+static void complete_rq_drain_wrs(struct c4iw_qp *qhp, struct ib_recv_wr *wr)
+{
+	while (wr) {
+		complete_rq_drain_wr(qhp, wr);
+		wr = wr->next;
+	}
+}
+
 int c4iw_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		   struct ib_send_wr **bad_wr)
 {
@@ -913,7 +937,7 @@ int c4iw_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	 */
 	if (qhp->wq.flushed) {
 		spin_unlock_irqrestore(&qhp->lock, flag);
-		err = complete_sq_drain_wr(qhp, wr);
+		err = complete_sq_drain_wrs(qhp, wr, bad_wr);
 		return err;
 	}
 	num_wrs = t4_sq_avail(&qhp->wq);
@@ -1061,7 +1085,7 @@ int c4iw_post_receive(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 	 */
 	if (qhp->wq.flushed) {
 		spin_unlock_irqrestore(&qhp->lock, flag);
-		complete_rq_drain_wr(qhp, wr);
+		complete_rq_drain_wrs(qhp, wr);
 		return err;
 	}
 	num_wrs = t4_rq_avail(&qhp->wq);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
