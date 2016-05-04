From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 8/9] RDMA/iw_cxgb4: move QP -> ERROR on fatal disconnect errors
Date: Thu,  5 May 2016 01:27:36 +0530
Message-ID: <1462391857-20939-9-git-send-email-hariprasad@chelsio.com>
References: <1462391857-20939-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462391857-20939-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In c4iw_ep_disconnect(), if we fail to initiate a close operation, then
move the qp to ERROR to disassociate the ep from the qp.  Failure to do
this will leak the ep resources.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 44e0bc409d59..aea69ca495f3 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3509,6 +3509,19 @@ int c4iw_ep_disconnect(struct c4iw_ep *ep, int abrupt, gfp_t gfp)
 				stop_ep_timer(ep);
 				close_complete_upcall(ep, -EIO);
 			}
+			if (ep->com.qp) {
+				struct c4iw_qp_attributes attrs;
+
+				attrs.next_state = C4IW_QP_STATE_ERROR;
+				ret = c4iw_modify_qp(ep->com.qp->rhp,
+						     ep->com.qp,
+						     C4IW_QP_ATTR_NEXT_STATE,
+						     &attrs, 1);
+				if (ret)
+					pr_err(MOD
+					       "%s - qp <- error failed!\n",
+					       __func__);
+			}
 			fatal = 1;
 		}
 	}
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
