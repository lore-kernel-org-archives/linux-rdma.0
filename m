From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 9/9] RDMA/iw_cxgb4: remove abort_connection() usage from ep_timeout()
Date: Thu,  5 May 2016 01:27:37 +0530
Message-ID: <1462391857-20939-10-git-send-email-hariprasad@chelsio.com>
References: <1462391857-20939-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462391857-20939-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use c4iw_ep_disconnect() instead.  This is part of getting rid of
abort_connection() altogether so we properly clean up on send_abort()
failures.

This is the last user of abort_connection(), so remove it too.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index aea69ca495f3..d7f7ab34eeba 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1179,14 +1179,6 @@ static void close_complete_upcall(struct c4iw_ep *ep, int status)
 	}
 }
 
-static int abort_connection(struct c4iw_ep *ep, struct sk_buff *skb, gfp_t gfp)
-{
-	PDBG("%s ep %p tid %u\n", __func__, ep, ep->hwtid);
-	__state_set(&ep->com, ABORTING);
-	set_bit(ABORT_CONN, &ep->com.history);
-	return send_abort(ep, skb, gfp);
-}
-
 static void peer_close_upcall(struct c4iw_ep *ep)
 {
 	struct iw_cm_event event;
@@ -3977,9 +3969,9 @@ static void process_timeout(struct c4iw_ep *ep)
 			__func__, ep, ep->hwtid, ep->com.state);
 		abort = 0;
 	}
-	if (abort)
-		abort_connection(ep, NULL, GFP_KERNEL);
 	mutex_unlock(&ep->com.mutex);
+	if (abort)
+		c4iw_ep_disconnect(ep, 1, GFP_KERNEL);
 	c4iw_put_ep(&ep->com);
 }
 
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
