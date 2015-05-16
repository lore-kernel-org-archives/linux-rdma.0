From: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH for-4.1 03/11] RDMA/ocrdma: Fix QP state transition in destroy_qp
Date: Sat, 16 May 2015 13:21:41 +0530
Message-ID: <1431762709-20740-4-git-send-email-selvin.xavier@avagotech.com>
References: <1431762709-20740-1-git-send-email-selvin.xavier@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431762709-20740-1-git-send-email-selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>

Don't move QP to error state, if QP is in reset state during QP
destroy operation.

Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 8771755..06e8ab7 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1721,18 +1721,20 @@ int ocrdma_destroy_qp(struct ib_qp *ibqp)
 	struct ocrdma_qp *qp;
 	struct ocrdma_dev *dev;
 	struct ib_qp_attr attrs;
-	int attr_mask = IB_QP_STATE;
+	int attr_mask;
 	unsigned long flags;
 
 	qp = get_ocrdma_qp(ibqp);
 	dev = get_ocrdma_dev(ibqp->device);
 
-	attrs.qp_state = IB_QPS_ERR;
 	pd = qp->pd;
 
 	/* change the QP state to ERROR */
-	_ocrdma_modify_qp(ibqp, &attrs, attr_mask);
-
+	if (qp->state != OCRDMA_QPS_RST) {
+		attrs.qp_state = IB_QPS_ERR;
+		attr_mask = IB_QP_STATE;
+		_ocrdma_modify_qp(ibqp, &attrs, attr_mask);
+	}
 	/* ensure that CQEs for newly created QP (whose id may be same with
 	 * one which just getting destroyed are same), dont get
 	 * discarded until the old CQEs are discarded.
-- 
2.2.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
