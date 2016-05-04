From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 4/9] RDMA/iw_cxgb4: remove connection abort from process_mpa_reply
Date: Thu,  5 May 2016 01:27:32 +0530
Message-ID: <1462391857-20939-5-git-send-email-hariprasad@chelsio.com>
References: <1462391857-20939-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462391857-20939-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Instead, have the caller, rx_data() handle the close/abort like
it does for process_mpa_request(). This is part of getting rid of
abort_connection() altogether so we properly clean up on send_abort()
failures.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 12eac98661c1..c4ce707d210b 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1346,6 +1346,18 @@ static int update_rx_credits(struct c4iw_ep *ep, u32 credits)
 
 #define RELAXED_IRD_NEGOTIATION 1
 
+/*
+ * process_mpa_reply - process streaming mode MPA reply
+ *
+ * Returns:
+ *
+ * 0 upon success indicating a connect request was delivered to the ULP
+ * or the mpa request is incomplete but valid so far.
+ *
+ * 1 if a failure requires the caller to close the connection.
+ *
+ * 2 if a failure requires the caller to abort the connection.
+ */
 static int process_mpa_reply(struct c4iw_ep *ep, struct sk_buff *skb)
 {
 	struct mpa_message *mpa;
@@ -1575,8 +1587,7 @@ static int process_mpa_reply(struct c4iw_ep *ep, struct sk_buff *skb)
 	}
 	goto out;
 err:
-	__state_set(&ep->com, ABORTING);
-	send_abort(ep, skb, GFP_KERNEL);
+	disconnect = 2;
 out:
 	connect_reply_upcall(ep, err);
 	return disconnect;
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
