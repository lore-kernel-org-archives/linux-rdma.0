From: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/1] RDMA/iw_cxgb4: Avoid touch after free error in ARP failure handlers
Date: Thu, 11 May 2017 17:13:54 +0530
Message-ID: <20170511114354.25046-1-rajur@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The patch 761e19a504af: "RDMA/iw_cxgb4: Handle return value of
c4iw_ofld_send() in abort_arp_failure()" from May 6, 2016, leads to the
following static checker warning:
	drivers/infiniband/hw/cxgb4/cm.c:575 abort_arp_failure()
	warn: passing freed memory 'skb'

Also fixes skb leak when l2t resolution fails

Fixes: 761e19a504afa55 (RDMA/iw_cxgb4: Handle return value of
c4iw_ofld_send() in abort_arp_failure())

Signed-off-by: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index b6fe45924c6e..06b110213e92 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -488,6 +488,7 @@ static int _put_ep_safe(struct c4iw_dev *dev, struct sk_buff *skb)
 
 	ep = *((struct c4iw_ep **)(skb->cb + 2 * sizeof(void *)));
 	release_ep_resources(ep);
+	kfree_skb(skb);
 	return 0;
 }
 
@@ -498,6 +499,7 @@ static int _put_pass_ep_safe(struct c4iw_dev *dev, struct sk_buff *skb)
 	ep = *((struct c4iw_ep **)(skb->cb + 2 * sizeof(void *)));
 	c4iw_put_ep(&ep->parent_ep->com);
 	release_ep_resources(ep);
+	kfree_skb(skb);
 	return 0;
 }
 
@@ -569,11 +571,13 @@ static void abort_arp_failure(void *handle, struct sk_buff *skb)
 
 	pr_debug("%s rdev %p\n", __func__, rdev);
 	req->cmd = CPL_ABORT_NO_RST;
+	skb_get(skb);
 	ret = c4iw_ofld_send(rdev, skb);
 	if (ret) {
 		__state_set(&ep->com, DEAD);
 		queue_arp_failure_cpl(ep, skb, FAKE_CPL_PUT_EP_SAFE);
-	}
+	} else
+		kfree_skb(skb);
 }
 
 static int send_flowc(struct c4iw_ep *ep)
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
