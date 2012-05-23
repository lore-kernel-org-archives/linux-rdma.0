From: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] RDMA/ocrdma: fixed enum for SRQ_LIMIT_REACHED.
Date: Wed, 23 May 2012 21:11:17 +0530
Message-ID: <13ab7f76-c50c-4560-9c88-43fda1818473@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mahesh.Vardhamanaiah-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org, Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fixed enum value for SRQ_LIMIT_REACHED async event.

Signed-off-by: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index f26314f..9343a15 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -732,7 +732,7 @@ static void ocrdma_dispatch_ibevent(struct ocrdma_dev *dev,
 		break;
 	case OCRDMA_SRQ_LIMIT_EVENT:
 		ib_evt.element.srq = &qp->srq->ibsrq;
-		ib_evt.event = IB_EVENT_QP_LAST_WQE_REACHED;
+		ib_evt.event = IB_EVENT_SRQ_LIMIT_REACHED;
 		srq_event = 1;
 		qp_event = 0;
 		break;
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
