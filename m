From: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] RDMA/qedr: lower print level of flushed CQEs
Date: Thu, 25 Jan 2018 13:23:20 +0200
Message-ID: <1516879400-8000-1-git-send-email-Michal.Kalderon@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: michal.kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There are races where can still get flush on CQEs before the QP enters
error state. This is not an error and should be treated as
debug information.

Signed-off-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index b26aa88..9f72164 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -3471,9 +3471,9 @@ static int qedr_poll_cq_req(struct qedr_dev *dev,
 		break;
 	case RDMA_CQE_REQ_STS_WORK_REQUEST_FLUSHED_ERR:
 		if (qp->state != QED_ROCE_QP_STATE_ERR)
-			DP_ERR(dev,
-			       "Error: POLL CQ with RDMA_CQE_REQ_STS_WORK_REQUEST_FLUSHED_ERR. CQ icid=0x%x, QP icid=0x%x\n",
-			       cq->icid, qp->icid);
+			DP_DEBUG(dev, QEDR_MSG_CQ,
+				 "Error: POLL CQ with RDMA_CQE_REQ_STS_WORK_REQUEST_FLUSHED_ERR. CQ icid=0x%x, QP icid=0x%x\n",
+				 cq->icid, qp->icid);
 		cnt = process_req(dev, qp, cq, num_entries, wc, req->sq_cons,
 				  IB_WC_WR_FLUSH_ERR, 1);
 		break;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
