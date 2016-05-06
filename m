From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 17/17] RDMA/iw_cxgb4: Add arp failure handlers to send_mpa_reply/reject()
Date: Fri,  6 May 2016 22:18:10 +0530
Message-ID: <1462553290-16422-18-git-send-email-hariprasad@chelsio.com>
References: <1462553290-16422-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462553290-16422-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

These handlers when called print error message to the kernel log,
but the actual handling is done by _c4iw_free_ep() and process_timeout().

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 4f8afa2b8e21..c4b7f1f8f8a5 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -515,6 +515,11 @@ static void arp_failure_discard(void *handle, struct sk_buff *skb)
 	kfree_skb(skb);
 }
 
+static void mpa_start_arp_failure(void *handle, struct sk_buff *skb)
+{
+	pr_err("ARP failure during MPA Negotiation - Closing Connection\n");
+}
+
 enum {
 	NUM_FAKE_CPLS = 2,
 	FAKE_CPL_PUT_EP_SAFE = NUM_CPL_CMDS + 0,
@@ -1118,6 +1123,7 @@ static int send_mpa_reject(struct c4iw_ep *ep, const void *pdata, u8 plen)
 	 */
 	skb_get(skb);
 	set_wr_txq(skb, CPL_PRIORITY_DATA, ep->txq_idx);
+	t4_set_arp_err_handler(skb, NULL, mpa_start_arp_failure);
 	BUG_ON(ep->mpa_skb);
 	ep->mpa_skb = skb;
 	ep->snd_seq += mpalen;
@@ -1202,6 +1208,7 @@ static int send_mpa_reply(struct c4iw_ep *ep, const void *pdata, u8 plen)
 	 * Function fw4_ack() will deref it.
 	 */
 	skb_get(skb);
+	t4_set_arp_err_handler(skb, NULL, mpa_start_arp_failure);
 	ep->mpa_skb = skb;
 	__state_set(&ep->com, MPA_REP_SENT);
 	ep->snd_seq += mpalen;
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
