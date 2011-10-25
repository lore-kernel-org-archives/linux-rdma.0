From: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] RDMA/cxgb4: Mark the QP in error before disabling the Q in the firmware
Date: Tue, 25 Oct 2011 16:38:30 +0530
Message-ID: <1319540910-443-1-git-send-email-kumaras@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, tom-/Yg/VP3ZvrM@public.gmane.org, Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>

The QP needs to be moved to error before telling the firwmare
to shutdown the queue. Otherwise, the application can submit
WR that will never get fetched by the hardware and never
flushed by the driver.

Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/qp.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index a391a4a..d6ccc7e 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1226,6 +1226,8 @@ int c4iw_modify_qp(struct c4iw_dev *rhp, struct c4iw_qp *qhp,
 				disconnect = 1;
 				c4iw_get_ep(&qhp->ep->com);
 			}
+			if (qhp->ibqp.uobject)
+				t4_set_wq_in_error(&qhp->wq);
 			ret = rdma_fini(rhp, qhp, ep);
 			if (ret)
 				goto err;
@@ -1244,6 +1246,8 @@ int c4iw_modify_qp(struct c4iw_dev *rhp, struct c4iw_qp *qhp,
 			break;
 		case C4IW_QP_STATE_ERROR:
 			set_state(qhp, C4IW_QP_STATE_ERROR);
+			if (qhp->ibqp.uobject)
+				t4_set_wq_in_error(&qhp->wq);
 			if (!internal) {
 				abort = 1;
 				disconnect = 1;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
