From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/5 v2] qedr: remove CQ spinlock from RDMA CM completion  handlers
Date: Tue, 24 Jan 2017 13:50:36 +0200
Message-ID: <1485258638-11884-4-git-send-email-Ram.Amrani@cavium.com>
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

There is only a single event queue that triggers the completion
events for the RDMA CM and it is being processed serially. This means
that inherently there can no parallelism of CQ completion handler.
Hence the lock is redundant.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/qedr.h    |  3 ---
 drivers/infiniband/hw/qedr/qedr_cm.c | 10 ++--------
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index 620badd..94319ab 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -251,9 +251,6 @@ struct qedr_cq {
 
 	u16 icid;
 
-	/* Lock to protect completion handler */
-	spinlock_t comp_handler_lock;
-
 	/* Lock to protect multiplem CQ's */
 	spinlock_t cq_lock;
 	u8 arm_flags;
diff --git a/drivers/infiniband/hw/qedr/qedr_cm.c b/drivers/infiniband/hw/qedr/qedr_cm.c
index 63890eb..00361f3 100644
--- a/drivers/infiniband/hw/qedr/qedr_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_cm.c
@@ -87,11 +87,8 @@ void qedr_ll2_tx_cb(void *_qdev, struct qed_roce_ll2_packet *pkt)
 	qedr_inc_sw_gsi_cons(&qp->sq);
 	spin_unlock_irqrestore(&qp->q_lock, flags);
 
-	if (cq->ibcq.comp_handler) {
-		spin_lock_irqsave(&cq->comp_handler_lock, flags);
+	if (cq->ibcq.comp_handler)
 		(*cq->ibcq.comp_handler) (&cq->ibcq, cq->ibcq.cq_context);
-		spin_unlock_irqrestore(&cq->comp_handler_lock, flags);
-	}
 }
 
 void qedr_ll2_rx_cb(void *_dev, struct qed_roce_ll2_packet *pkt,
@@ -113,11 +110,8 @@ void qedr_ll2_rx_cb(void *_dev, struct qed_roce_ll2_packet *pkt,
 
 	spin_unlock_irqrestore(&qp->q_lock, flags);
 
-	if (cq->ibcq.comp_handler) {
-		spin_lock_irqsave(&cq->comp_handler_lock, flags);
+	if (cq->ibcq.comp_handler)
 		(*cq->ibcq.comp_handler) (&cq->ibcq, cq->ibcq.cq_context);
-		spin_unlock_irqrestore(&cq->comp_handler_lock, flags);
-	}
 }
 
 static void qedr_destroy_gsi_cq(struct qedr_dev *dev,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
