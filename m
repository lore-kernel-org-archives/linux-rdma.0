From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-rc] RDMA/vmw_pvrdma: Report CQ missed events
Date: Thu, 10 Aug 2017 00:46:15 -0700
Message-ID: <1502351175-1762-1-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
Cc: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>

There is a chance of a race between arming the CQ and receiving
completions. By reporting CQ missed events any ULPs should poll
again to get the completions.

Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
Acked-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
index 69bda61..f4ab5fa 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
@@ -65,12 +65,27 @@ int pvrdma_req_notify_cq(struct ib_cq *ibcq,
 	struct pvrdma_dev *dev = to_vdev(ibcq->device);
 	struct pvrdma_cq *cq = to_vcq(ibcq);
 	u32 val = cq->cq_handle;
+	unsigned long flags;
 
 	val |= (notify_flags & IB_CQ_SOLICITED_MASK) == IB_CQ_SOLICITED ?
 		PVRDMA_UAR_CQ_ARM_SOL : PVRDMA_UAR_CQ_ARM;
 
+	spin_lock_irqsave(&cq->cq_lock, flags);
+
 	pvrdma_write_uar_cq(dev, val);
 
+	if (notify_flags & IB_CQ_REPORT_MISSED_EVENTS) {
+		unsigned int head;
+
+		if (pvrdma_idx_ring_has_data(&cq->ring_state->rx,
+					     cq->ibcq.cqe, &head)) {
+			spin_unlock_irqrestore(&cq->cq_lock, flags);
+			return 1;
+		}
+	}
+
+	spin_unlock_irqrestore(&cq->cq_lock, flags);
+
 	return 0;
 }
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
