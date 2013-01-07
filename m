From: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 09/11] RDMA/cxgb4: Don't wakeup threads for MPAv2
Date: Mon,  7 Jan 2013 18:41:58 +0530
Message-ID: <1357564320-15022-10-git-send-email-vipul@chelsio.com>
References: <1357564320-15022-1-git-send-email-vipul@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357564320-15022-1-git-send-email-vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, abhishek-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Don't wakeup threads blocked in rdma_init/rdma_fini if we are on
MPAv2, and want to retry connection with MPAv1.

Stop ep-timer on getting MPA version mismatch, before doing the
abort_connection - in process_mpa_request.

Take care to stop ep-timer in error paths for process_mpa_request.

Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 88933af..06c3a52 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1300,11 +1300,13 @@ static void process_mpa_request(struct c4iw_ep *ep, struct sk_buff *skb)
 	if (mpa->revision > mpa_rev) {
 		printk(KERN_ERR MOD "%s MPA version mismatch. Local = %d,"
 		       " Received = %d\n", __func__, mpa_rev, mpa->revision);
+		stop_ep_timer(ep);
 		abort_connection(ep, skb, GFP_KERNEL);
 		return;
 	}
 
 	if (memcmp(mpa->key, MPA_KEY_REQ, sizeof(mpa->key))) {
+		stop_ep_timer(ep);
 		abort_connection(ep, skb, GFP_KERNEL);
 		return;
 	}
@@ -1315,6 +1317,7 @@ static void process_mpa_request(struct c4iw_ep *ep, struct sk_buff *skb)
 	 * Fail if there's too much private data.
 	 */
 	if (plen > MPA_MAX_PRIVATE_DATA) {
+		stop_ep_timer(ep);
 		abort_connection(ep, skb, GFP_KERNEL);
 		return;
 	}
@@ -1323,6 +1326,7 @@ static void process_mpa_request(struct c4iw_ep *ep, struct sk_buff *skb)
 	 * If plen does not account for pkt size
 	 */
 	if (ep->mpa_pkt_len > (sizeof(*mpa) + plen)) {
+		stop_ep_timer(ep);
 		abort_connection(ep, skb, GFP_KERNEL);
 		return;
 	}
@@ -3286,8 +3290,14 @@ static int peer_abort_intr(struct c4iw_dev *dev, struct sk_buff *skb)
 
 	/*
 	 * Wake up any threads in rdma_init() or rdma_fini().
+	 * However, if we are on MPAv2 and want to retry with MPAv1
+	 * then, don't wake up yet.
 	 */
-	c4iw_wake_up(&ep->com.wr_wait, -ECONNRESET);
+	if (mpa_rev == 2 && !ep->tried_with_mpa_v1) {
+		if (ep->com.state != MPA_REQ_SENT)
+			c4iw_wake_up(&ep->com.wr_wait, -ECONNRESET);
+	} else
+		c4iw_wake_up(&ep->com.wr_wait, -ECONNRESET);
 	sched(dev, skb);
 	return 0;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
