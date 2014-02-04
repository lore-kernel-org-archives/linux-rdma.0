From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 12/17] RDMA/ocrdma: Handle CQ overrun error
Date: Tue, 4 Feb 2014 11:57:05 +0530
Message-ID: <69264470-f4d5-4ecd-8c04-d987e452693e@CMEXHTCAS2.ad.emulex.com>
References: <1391495230-28021-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391495230-28021-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, selvin.xavier-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Update the variables to handle CQ overrun errors

Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 2ed6aa1..6a36476 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -640,7 +640,7 @@ static void ocrdma_dispatch_ibevent(struct ocrdma_dev *dev,
 {
 	struct ocrdma_qp *qp = NULL;
 	struct ocrdma_cq *cq = NULL;
-	struct ib_event ib_evt;
+	struct ib_event ib_evt = { 0 };
 	int cq_event = 0;
 	int qp_event = 1;
 	int srq_event = 0;
@@ -665,6 +665,8 @@ static void ocrdma_dispatch_ibevent(struct ocrdma_dev *dev,
 	case OCRDMA_CQ_OVERRUN_ERROR:
 		ib_evt.element.cq = &cq->ibcq;
 		ib_evt.event = IB_EVENT_CQ_ERR;
+		cq_event = 1;
+		qp_event = 0;
 		break;
 	case OCRDMA_CQ_QPCAT_ERROR:
 		ib_evt.element.qp = &qp->ibqp;
@@ -726,6 +728,7 @@ static void ocrdma_dispatch_ibevent(struct ocrdma_dev *dev,
 						     qp->srq->ibsrq.
 						     srq_context);
 	} else if (dev_event) {
+		pr_err("%s: Fatal event received\n", dev->ibdev.name);
 		ib_dispatch_event(&ib_evt);
 	}
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
