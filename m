From: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 5/8] RDMA/cxgb4: Set arp error handler for PASS_ACCEPT_RPL messages.
Date: Tue,  6 Aug 2013 21:04:37 +0530
Message-ID: <1375803280-7916-6-git-send-email-vipul@chelsio.com>
References: <1375803280-7916-1-git-send-email-vipul@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375803280-7916-1-git-send-email-vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

accept_cr() failed to set the arp error handler on a reused skb.
This results in a kernel crash if the arp does indeed time out.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 1b0fd72..e95c6ba 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -332,6 +332,7 @@ static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp)
 	} else {
 		skb = alloc_skb(len, gfp);
 	}
+	t4_set_arp_err_handler(skb, NULL, NULL);
 	return skb;
 }
 
@@ -2018,6 +2019,7 @@ static void accept_cr(struct c4iw_ep *ep, struct sk_buff *skb,
 	rpl->opt0 = cpu_to_be64(opt0);
 	rpl->opt2 = cpu_to_be32(opt2);
 	set_wr_txq(skb, CPL_PRIORITY_SETUP, ep->ctrlq_idx);
+	t4_set_arp_err_handler(skb, NULL, arp_failure_discard);
 	c4iw_l2t_send(&ep->com.dev->rdev, skb, ep->l2t);
 
 	return;
-- 
1.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
