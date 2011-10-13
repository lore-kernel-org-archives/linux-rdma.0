From: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] RDMA/cxgb4: Unblock reads on comp_channel
Date: Thu, 13 Oct 2011 13:51:30 +0530
Message-ID: <1318494090-9996-1-git-send-email-kumaras@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

At the time when peer closes connection, iw_cxgb4 will not
send a cq event if ibqp.uobject exists. In that case, its possible
for user application to get blocked in ibv_get_cq_event.

To resolve this, call the cq's comp_handler to unblock any read
from ibv_get_cq_event.

Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/qp.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index ec3ce67..b59b56c 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -970,8 +970,12 @@ static void flush_qp(struct c4iw_qp *qhp)
 	if (qhp->ibqp.uobject) {
 		t4_set_wq_in_error(&qhp->wq);
 		t4_set_cq_in_error(&rchp->cq);
-		if (schp != rchp)
+		(*rchp->ibcq.comp_handler)(&rchp->ibcq, rchp->ibcq.cq_context);
+		if (schp != rchp) {
 			t4_set_cq_in_error(&schp->cq);
+			(*schp->ibcq.comp_handler)(&schp->ibcq,
+					schp->ibcq.cq_context);
+		}
 		return;
 	}
 	__flush_qp(qhp, rchp, schp);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
