From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/8] qedr: modify QP state to error when destroying it
Date: Thu, 22 Dec 2016 14:40:36 +0200
Message-ID: <1482410440-2297-5-git-send-email-Ram.Amrani@cavium.com>
References: <1482410440-2297-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482410440-2297-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Current code didn't modify the QP state to error because it queried the
QP state as a bitmap while it isn't. So the code never got executed.
This patch fixes this and queries for each QP state respectively and not
at once via a bitmask.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 247c407..e95b19f 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -2072,8 +2072,10 @@ int qedr_destroy_qp(struct ib_qp *ibqp)
 	DP_DEBUG(dev, QEDR_MSG_QP, "destroy qp: destroying %p, qp type=%d\n",
 		 qp, qp->qp_type);
 
-	if (qp->state != (QED_ROCE_QP_STATE_RESET | QED_ROCE_QP_STATE_ERR |
-			  QED_ROCE_QP_STATE_INIT)) {
+	if ((qp->state != QED_ROCE_QP_STATE_RESET) &&
+	    (qp->state != QED_ROCE_QP_STATE_ERR) &&
+	    (qp->state != QED_ROCE_QP_STATE_INIT)) {
+
 		attr.qp_state = IB_QPS_ERR;
 		attr_mask |= IB_QP_STATE;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
