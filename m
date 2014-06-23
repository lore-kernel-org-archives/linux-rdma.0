From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 2/2] iw_cxgb4: clean up connection on arp error
Date: Mon, 23 Jun 2014 19:12:36 +0530
Message-ID: <1403530956-16135-3-git-send-email-hariprasad@chelsio.com>
References: <1403530956-16135-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403530956-16135-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Based on origninal work by Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index cc36e9b..6a93280 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -432,8 +432,17 @@ static void arp_failure_discard(void *handle, struct sk_buff *skb)
  */
 static void act_open_req_arp_failure(void *handle, struct sk_buff *skb)
 {
+	struct c4iw_ep *ep = handle;
+
 	printk(KERN_ERR MOD "ARP failure duing connect\n");
 	kfree_skb(skb);
+	connect_reply_upcall(ep, -EHOSTUNREACH);
+	state_set(&ep->com, DEAD);
+	remove_handle(ep->com.dev, &ep->com.dev->atid_idr, ep->atid);
+	cxgb4_free_atid(ep->com.dev->rdev.lldi.tids, ep->atid);
+	dst_release(ep->dst);
+	cxgb4_l2t_release(ep->l2t);
+	c4iw_put_ep(&ep->com);
 }
 
 /*
@@ -658,7 +667,7 @@ static int send_connect(struct c4iw_ep *ep)
 		opt2 |= T5_OPT_2_VALID;
 		opt2 |= V_CONG_CNTRL(CONG_ALG_TAHOE);
 	}
-	t4_set_arp_err_handler(skb, NULL, act_open_req_arp_failure);
+	t4_set_arp_err_handler(skb, ep, act_open_req_arp_failure);
 
 	if (is_t4(ep->com.dev->rdev.lldi.adapter_type)) {
 		if (ep->com.remote_addr.ss_family == AF_INET) {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
