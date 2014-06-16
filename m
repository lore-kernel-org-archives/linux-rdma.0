From: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] infinibad: fix memory leak in function send_flowc
Date: Mon, 16 Jun 2014 14:30:56 -0400
Message-ID: <1402943456-7532-1-git-send-email-xerofoify@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 5e153f6..c518411 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -455,7 +455,10 @@ static void send_flowc(struct c4iw_ep *ep, struct sk_buff *skb)
 	unsigned int flowclen = 80;
 	struct fw_flowc_wr *flowc;
 	int i;

+	if (!skb) {
+		kfree_skb();
+		pr_warn(MOD "%s failed to allocate skb.\n", __func__);
+	}
 	skb = get_skb(skb, flowclen, GFP_KERNEL);
 	flowc = (struct fw_flowc_wr *)__skb_put(skb, flowclen);
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
