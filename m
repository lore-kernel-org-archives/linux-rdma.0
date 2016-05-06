From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 05/17] RDMA/iw_cxgb4: Do not stop timer in case of incomplete messages
Date: Fri,  6 May 2016 22:17:58 +0530
Message-ID: <1462553290-16422-6-git-send-email-hariprasad@chelsio.com>
References: <1462553290-16422-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462553290-16422-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In case of incomplete mpa messages we should not stop timer as it
results in return with timeout for the next mpa message

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index cae1794cef83..c7b3d5751963 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1396,20 +1396,12 @@ static int process_mpa_reply(struct c4iw_ep *ep, struct sk_buff *skb)
 	PDBG("%s ep %p tid %u\n", __func__, ep, ep->hwtid);
 
 	/*
-	 * Stop mpa timer.  If it expired, then
-	 * we ignore the MPA reply.  process_timeout()
-	 * will abort the connection.
-	 */
-	if (stop_ep_timer(ep))
-		return 0;
-
-	/*
 	 * If we get more than the supported amount of private data
 	 * then we must fail this connection.
 	 */
 	if (ep->mpa_pkt_len + skb->len > sizeof(ep->mpa_pkt)) {
 		err = -EINVAL;
-		goto err;
+		goto err_stop_timer;
 	}
 
 	/*
@@ -1431,11 +1423,11 @@ static int process_mpa_reply(struct c4iw_ep *ep, struct sk_buff *skb)
 		printk(KERN_ERR MOD "%s MPA version mismatch. Local = %d,"
 		       " Received = %d\n", __func__, mpa_rev, mpa->revision);
 		err = -EPROTO;
-		goto err;
+		goto err_stop_timer;
 	}
 	if (memcmp(mpa->key, MPA_KEY_REP, sizeof(mpa->key))) {
 		err = -EPROTO;
-		goto err;
+		goto err_stop_timer;
 	}
 
 	plen = ntohs(mpa->private_data_size);
@@ -1445,7 +1437,7 @@ static int process_mpa_reply(struct c4iw_ep *ep, struct sk_buff *skb)
 	 */
 	if (plen > MPA_MAX_PRIVATE_DATA) {
 		err = -EPROTO;
-		goto err;
+		goto err_stop_timer;
 	}
 
 	/*
@@ -1453,7 +1445,7 @@ static int process_mpa_reply(struct c4iw_ep *ep, struct sk_buff *skb)
 	 */
 	if (ep->mpa_pkt_len > (sizeof(*mpa) + plen)) {
 		err = -EPROTO;
-		goto err;
+		goto err_stop_timer;
 	}
 
 	ep->plen = (u8) plen;
@@ -1467,10 +1459,18 @@ static int process_mpa_reply(struct c4iw_ep *ep, struct sk_buff *skb)
 
 	if (mpa->flags & MPA_REJECT) {
 		err = -ECONNREFUSED;
-		goto err;
+		goto err_stop_timer;
 	}
 
 	/*
+	 * Stop mpa timer.  If it expired, then
+	 * we ignore the MPA reply.  process_timeout()
+	 * will abort the connection.
+	 */
+	if (stop_ep_timer(ep))
+		return 0;
+
+	/*
 	 * If we get here we have accumulated the entire mpa
 	 * start reply message including private data. And
 	 * the MPA header is valid.
@@ -1609,6 +1609,8 @@ static int process_mpa_reply(struct c4iw_ep *ep, struct sk_buff *skb)
 		goto out;
 	}
 	goto out;
+err_stop_timer:
+	stop_ep_timer(ep);
 err:
 	disconnect = 2;
 out:
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
