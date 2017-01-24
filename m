From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/5 v2] qedr: fail QP state transition from error to reset if SQ/RQ are not empty
Date: Tue, 24 Jan 2017 13:50:38 +0200
Message-ID: <1485258638-11884-6-git-send-email-Ram.Amrani@cavium.com>
References: <1485258638-11884-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485258638-11884-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 564080a..189f9bd 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -1733,6 +1733,14 @@ static int qedr_update_qp_state(struct qedr_dev *dev,
 		/* ERR->XXX */
 		switch (new_state) {
 		case QED_ROCE_QP_STATE_RESET:
+			if ((qp->rq.prod != qp->rq.cons) ||
+			    (qp->sq.prod != qp->sq.cons)) {
+				DP_NOTICE(dev,
+					  "Error->Reset with rq/sq not empty rq.prod=%x rq.cons=%x sq.prod=%x sq.cons=%x\n",
+					  qp->rq.prod, qp->rq.cons, qp->sq.prod,
+					  qp->sq.cons);
+				status = -EINVAL;
+			}
 			break;
 		default:
 			status = -EINVAL;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
