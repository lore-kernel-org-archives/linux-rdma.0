From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] iw_cxgb4: set *bad_wr for post_send/post_recv errors
Date: Tue, 18 Oct 2016 14:04:39 -0700
Message-ID: <20161018210618.049C1E0AD3@smtp.ogc.us>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

There are a few cases in c4iw_post_send() and c4iw_post_receive()
where *bad_wr is not set when an error is returned.  This can
cause a crash if the application tries to use bad_wr.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/qp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 6904352..c09fbf3 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -762,11 +762,13 @@ int c4iw_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	spin_lock_irqsave(&qhp->lock, flag);
 	if (t4_wq_in_error(&qhp->wq)) {
 		spin_unlock_irqrestore(&qhp->lock, flag);
+		*bad_wr = wr;
 		return -EINVAL;
 	}
 	num_wrs = t4_sq_avail(&qhp->wq);
 	if (num_wrs == 0) {
 		spin_unlock_irqrestore(&qhp->lock, flag);
+		*bad_wr = wr;
 		return -ENOMEM;
 	}
 	while (wr) {
@@ -885,11 +887,13 @@ int c4iw_post_receive(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 	spin_lock_irqsave(&qhp->lock, flag);
 	if (t4_wq_in_error(&qhp->wq)) {
 		spin_unlock_irqrestore(&qhp->lock, flag);
+		*bad_wr = wr;
 		return -EINVAL;
 	}
 	num_wrs = t4_rq_avail(&qhp->wq);
 	if (num_wrs == 0) {
 		spin_unlock_irqrestore(&qhp->lock, flag);
+		*bad_wr = wr;
 		return -ENOMEM;
 	}
 	while (wr) {
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
