From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/4] RDMA/ocrdma: Set event's device member in ocrdma_dispatch_ibevent()
Date: Tue, 24 Apr 2012 16:49:44 -0700
Message-ID: <1335311385-11381-4-git-send-email-roland@kernel.org>
References: <1335311385-11381-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335311385-11381-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

We need to set ib_evt.device, or else ib_dispatch_event() will crash
when we call it for unaffiliated events (and consumers may get
confused in their QP/CQ/SRQ event handler for affiliated events).

Also fix sparse warning:

    drivers/infiniband/hw/ocrdma/ocrdma_hw.c:678:36: warning: Using plain integer as NULL pointer

There's no need to clear ib_evt, since every member is initialized.

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 00a460e..5af30f1 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -675,7 +675,7 @@ static void ocrdma_dispatch_ibevent(struct ocrdma_dev *dev,
 {
 	struct ocrdma_qp *qp = NULL;
 	struct ocrdma_cq *cq = NULL;
-	struct ib_event ib_evt = { 0 };
+	struct ib_event ib_evt;
 	int cq_event = 0;
 	int qp_event = 1;
 	int srq_event = 0;
@@ -688,6 +688,8 @@ static void ocrdma_dispatch_ibevent(struct ocrdma_dev *dev,
 	if (cqe->cqvalid_cqid & OCRDMA_AE_MCQE_CQVALID)
 		cq = dev->cq_tbl[cqe->cqvalid_cqid & OCRDMA_AE_MCQE_CQID_MASK];
 
+	ib_evt.device = &dev->ibdev;
+
 	switch (type) {
 	case OCRDMA_CQ_ERROR:
 		ib_evt.element.cq = &cq->ibcq;
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
