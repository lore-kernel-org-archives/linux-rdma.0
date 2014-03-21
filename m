From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 5/8] iw_cxgb4: update snd_seq when sending MPA messages
Date: Fri, 21 Mar 2014 20:40:34 +0530
Message-ID: <1395414637-8298-6-git-send-email-hariprasad@chelsio.com>
References: <1395414637-8298-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395414637-8298-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 6bfef31..a1bc41d 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -762,6 +762,7 @@ static void send_mpa_req(struct c4iw_ep *ep, struct sk_buff *skb,
 	start_ep_timer(ep);
 	state_set(&ep->com, MPA_REQ_SENT);
 	ep->mpa_attr.initiator = 1;
+	ep->snd_seq += mpalen;
 	return;
 }
 
@@ -841,6 +842,7 @@ static int send_mpa_reject(struct c4iw_ep *ep, const void *pdata, u8 plen)
 	t4_set_arp_err_handler(skb, NULL, arp_failure_discard);
 	BUG_ON(ep->mpa_skb);
 	ep->mpa_skb = skb;
+	ep->snd_seq += mpalen;
 	return c4iw_l2t_send(&ep->com.dev->rdev, skb, ep->l2t);
 }
 
@@ -925,6 +927,7 @@ static int send_mpa_reply(struct c4iw_ep *ep, const void *pdata, u8 plen)
 	t4_set_arp_err_handler(skb, NULL, arp_failure_discard);
 	ep->mpa_skb = skb;
 	state_set(&ep->com, MPA_REP_SENT);
+	ep->snd_seq += mpalen;
 	return c4iw_l2t_send(&ep->com.dev->rdev, skb, ep->l2t);
 }
 
-- 
1.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
