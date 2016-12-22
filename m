From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 6/8] qedr: post_send/recv according to QP state
Date: Thu, 22 Dec 2016 14:40:38 +0200
Message-ID: <1482410440-2297-7-git-send-email-Ram.Amrani@cavium.com>
References: <1482410440-2297-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482410440-2297-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Enable posting to SQ only in RTS, ERR and SQD QP state.
Enable posting to RQ in ERR QP state.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 16bbdfe..18341ed 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -2983,8 +2983,9 @@ int qedr_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 
 	spin_lock_irqsave(&qp->q_lock, flags);
 
-	if ((qp->state == QED_ROCE_QP_STATE_RESET) ||
-	    (qp->state == QED_ROCE_QP_STATE_ERR)) {
+	if ((qp->state != QED_ROCE_QP_STATE_RTS) &&
+	    (qp->state != QED_ROCE_QP_STATE_ERR) &&
+	    (qp->state != QED_ROCE_QP_STATE_SQD)) {
 		spin_unlock_irqrestore(&qp->q_lock, flags);
 		*bad_wr = wr;
 		DP_DEBUG(dev, QEDR_MSG_CQ,
@@ -3042,8 +3043,7 @@ int qedr_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 
 	spin_lock_irqsave(&qp->q_lock, flags);
 
-	if ((qp->state == QED_ROCE_QP_STATE_RESET) ||
-	    (qp->state == QED_ROCE_QP_STATE_ERR)) {
+	if (qp->state == QED_ROCE_QP_STATE_RESET) {
 		spin_unlock_irqrestore(&qp->q_lock, flags);
 		*bad_wr = wr;
 		return -EINVAL;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
