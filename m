From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 7/9] RDMA/iw_cxgb4: don't use abort_connection in process_mpa_request()
Date: Thu,  5 May 2016 01:27:35 +0530
Message-ID: <1462391857-20939-8-git-send-email-hariprasad@chelsio.com>
References: <1462391857-20939-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462391857-20939-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Instead return whether the caller needs to disconnect. This is part of
getting rid of abort_connection() altogether so we properly clean up on
send_abort() failures.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 64 ++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 29 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index d862369b5dd7..44e0bc409d59 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1601,7 +1601,19 @@ out:
 	return disconnect;
 }
 
-static void process_mpa_request(struct c4iw_ep *ep, struct sk_buff *skb)
+/*
+ * process_mpa_request - process streaming mode MPA request
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
+static int process_mpa_request(struct c4iw_ep *ep, struct sk_buff *skb)
 {
 	struct mpa_message *mpa;
 	struct mpa_v2_conn_params *mpa_v2_params;
@@ -1613,11 +1625,8 @@ static void process_mpa_request(struct c4iw_ep *ep, struct sk_buff *skb)
 	 * If we get more than the supported amount of private data
 	 * then we must fail this connection.
 	 */
-	if (ep->mpa_pkt_len + skb->len > sizeof(ep->mpa_pkt)) {
-		(void)stop_ep_timer(ep);
-		abort_connection(ep, skb, GFP_KERNEL);
-		return;
-	}
+	if (ep->mpa_pkt_len + skb->len > sizeof(ep->mpa_pkt))
+		goto err_stop_timer;
 
 	PDBG("%s enter (%s line %u)\n", __func__, __FILE__, __LINE__);
 
@@ -1633,7 +1642,7 @@ static void process_mpa_request(struct c4iw_ep *ep, struct sk_buff *skb)
 	 * We'll continue process when more data arrives.
 	 */
 	if (ep->mpa_pkt_len < sizeof(*mpa))
-		return;
+		return 0;
 
 	PDBG("%s enter (%s line %u)\n", __func__, __FILE__, __LINE__);
 	mpa = (struct mpa_message *) ep->mpa_pkt;
@@ -1644,43 +1653,32 @@ static void process_mpa_request(struct c4iw_ep *ep, struct sk_buff *skb)
 	if (mpa->revision > mpa_rev) {
 		printk(KERN_ERR MOD "%s MPA version mismatch. Local = %d,"
 		       " Received = %d\n", __func__, mpa_rev, mpa->revision);
-		(void)stop_ep_timer(ep);
-		abort_connection(ep, skb, GFP_KERNEL);
-		return;
+		goto err_stop_timer;
 	}
 
-	if (memcmp(mpa->key, MPA_KEY_REQ, sizeof(mpa->key))) {
-		(void)stop_ep_timer(ep);
-		abort_connection(ep, skb, GFP_KERNEL);
-		return;
-	}
+	if (memcmp(mpa->key, MPA_KEY_REQ, sizeof(mpa->key)))
+		goto err_stop_timer;
 
 	plen = ntohs(mpa->private_data_size);
 
 	/*
 	 * Fail if there's too much private data.
 	 */
-	if (plen > MPA_MAX_PRIVATE_DATA) {
-		(void)stop_ep_timer(ep);
-		abort_connection(ep, skb, GFP_KERNEL);
-		return;
-	}
+	if (plen > MPA_MAX_PRIVATE_DATA)
+		goto err_stop_timer;
 
 	/*
 	 * If plen does not account for pkt size
 	 */
-	if (ep->mpa_pkt_len > (sizeof(*mpa) + plen)) {
-		(void)stop_ep_timer(ep);
-		abort_connection(ep, skb, GFP_KERNEL);
-		return;
-	}
+	if (ep->mpa_pkt_len > (sizeof(*mpa) + plen))
+		goto err_stop_timer;
 	ep->plen = (u8) plen;
 
 	/*
 	 * If we don't have all the pdata yet, then bail.
 	 */
 	if (ep->mpa_pkt_len < (sizeof(*mpa) + plen))
-		return;
+		return 0;
 
 	/*
 	 * If we get here we have accumulated the entire mpa
@@ -1742,13 +1740,21 @@ static void process_mpa_request(struct c4iw_ep *ep, struct sk_buff *skb)
 				  SINGLE_DEPTH_NESTING);
 		if (ep->parent_ep->com.state != DEAD) {
 			if (connect_request_upcall(ep))
-				abort_connection(ep, skb, GFP_KERNEL);
+				goto err_unlock_parent;
 		} else {
-			abort_connection(ep, skb, GFP_KERNEL);
+			goto err_unlock_parent;
 		}
 		mutex_unlock(&ep->parent_ep->com.mutex);
 	}
-	return;
+	return 0;
+
+err_unlock_parent:
+	mutex_unlock(&ep->parent_ep->com.mutex);
+	goto err_out;
+err_stop_timer:
+	(void)stop_ep_timer(ep);
+err_out:
+	return 2;
 }
 
 static int rx_data(struct c4iw_dev *dev, struct sk_buff *skb)
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
