From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 08/17] RDMA/iw_cxgb4: in process_timeout() don't move ep state to ABORTING
Date: Fri,  6 May 2016 22:18:01 +0530
Message-ID: <1462553290-16422-9-git-send-email-hariprasad@chelsio.com>
References: <1462553290-16422-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462553290-16422-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Moving the state to ABORTING causes the ep to get stuck because
c4iw_ep_timeout() thinks the ABORT has already been done. So leave the
state alone and let c4iw_ep_disconnect() do the right thing given the
ep state.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 658ea16d3265..6c22bc95a112 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3971,12 +3971,10 @@ static void process_timeout(struct c4iw_ep *ep)
 	set_bit(TIMEDOUT, &ep->com.history);
 	switch (ep->com.state) {
 	case MPA_REQ_SENT:
-		__state_set(&ep->com, ABORTING);
 		connect_reply_upcall(ep, -ETIMEDOUT);
 		break;
 	case MPA_REQ_WAIT:
 	case MPA_REP_SENT:
-		__state_set(&ep->com, ABORTING);
 		break;
 	case CLOSING:
 	case MORIBUND:
@@ -3986,7 +3984,6 @@ static void process_timeout(struct c4iw_ep *ep)
 				     ep->com.qp, C4IW_QP_ATTR_NEXT_STATE,
 				     &attrs, 1);
 		}
-		__state_set(&ep->com, ABORTING);
 		close_complete_upcall(ep, -ETIMEDOUT);
 		break;
 	case ABORTING:
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
