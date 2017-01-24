From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/5 v2] qedr: avoid printing error messages for flushed CQEs if QP in error state
Date: Tue, 24 Jan 2017 13:50:37 +0200
Message-ID: <1485258638-11884-5-git-send-email-Ram.Amrani@cavium.com>
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

It is normal to flush CQEs if the QP is in error state. Hence there's no
use in printing a message per CQE to dmesg.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index e843501..564080a 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -3234,9 +3234,10 @@ static int qedr_poll_cq_req(struct qedr_dev *dev,
 				  IB_WC_SUCCESS, 0);
 		break;
 	case RDMA_CQE_REQ_STS_WORK_REQUEST_FLUSHED_ERR:
-		DP_ERR(dev,
-		       "Error: POLL CQ with RDMA_CQE_REQ_STS_WORK_REQUEST_FLUSHED_ERR. CQ icid=0x%x, QP icid=0x%x\n",
-		       cq->icid, qp->icid);
+		if (qp->state != QED_ROCE_QP_STATE_ERR)
+			DP_ERR(dev,
+			       "Error: POLL CQ with RDMA_CQE_REQ_STS_WORK_REQUEST_FLUSHED_ERR. CQ icid=0x%x, QP icid=0x%x\n",
+			       cq->icid, qp->icid);
 		cnt = process_req(dev, qp, cq, num_entries, wc, req->sq_cons,
 				  IB_WC_WR_FLUSH_ERR, 1);
 		break;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
