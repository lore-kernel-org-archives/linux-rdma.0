From: Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] ipoib: clear nfct state on xmit
Date: Thu,  2 Feb 2017 11:25:32 +0100
Message-ID: <b6fce27b7ffea97ee958578cc3cf0e8ae9393914.1486030684.git.pabeni@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

the skbs can be held by the driver for a long time, so we need
to clear any state on xmit to avoid hanging other subsystems.
The skbs are already orphaned and dsts are dropped, later in ib/cm
code, so we just need to clear the nf state.
Do it early, while the ct entry is hopefully still hot in the
cache.

Signed-off-by: Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 3ce0765..cb4ddaa 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1050,6 +1050,9 @@ static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct ipoib_header *header;
 	unsigned long flags;
 
+	/* we can held the skb for along time; avoid hanging ct */
+	nf_reset(skb);
+
 	phdr = (struct ipoib_pseudo_header *) skb->data;
 	skb_pull(skb, sizeof(*phdr));
 	header = (struct ipoib_header *) skb->data;
-- 
2.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
