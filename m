From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH 2/4] RDMA/ocrdma: Dispatch only port event when port state changes
Date: Thu, 24 Dec 2015 13:14:06 -0500
Message-ID: <1450980848-18945-3-git-send-email-devesh.sharma@avagotech.com>
References: <1450980848-18945-1-git-send-email-devesh.sharma@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450980848-18945-1-git-send-email-devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Padmanabh Ratnakar <padmanabh.ratnakar-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Dispatch only port event to IB stack when port state changes.
Don't explicitly modify qps to error. Let application listen to
port events on async event queue or let QP fail with retry-exceeded
completion error.

Signed-off-by: Padmanabh Ratnakar <padmanabh.ratnakar-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 62b7009..ebe40b4 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -386,30 +386,7 @@ static int ocrdma_open(struct ocrdma_dev *dev)
 
 static int ocrdma_close(struct ocrdma_dev *dev)
 {
-	int i;
-	struct ocrdma_qp *qp, **cur_qp;
 	struct ib_event err_event;
-	struct ib_qp_attr attrs;
-	int attr_mask = IB_QP_STATE;
-
-	attrs.qp_state = IB_QPS_ERR;
-	mutex_lock(&dev->dev_lock);
-	if (dev->qp_tbl) {
-		cur_qp = dev->qp_tbl;
-		for (i = 0; i < OCRDMA_MAX_QP; i++) {
-			qp = cur_qp[i];
-			if (qp && qp->ibqp.qp_type != IB_QPT_GSI) {
-				/* change the QP state to ERROR */
-				_ocrdma_modify_qp(&qp->ibqp, &attrs, attr_mask);
-
-				err_event.event = IB_EVENT_QP_FATAL;
-				err_event.element.qp = &qp->ibqp;
-				err_event.device = &dev->ibdev;
-				ib_dispatch_event(&err_event);
-			}
-		}
-	}
-	mutex_unlock(&dev->dev_lock);
 
 	err_event.event = IB_EVENT_PORT_ERR;
 	err_event.element.port_num = 1;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
