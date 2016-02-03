From: clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Subject: [PATCH] IB/IPoIB: Do not set skb truesize since using one linearskb
Date: Wed,  3 Feb 2016 15:55:37 -0500
Message-ID: <1454532937-22649-1-git-send-email-clsoto@linux.vnet.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Carol L Soto <clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Carol L Soto <clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

We are seeing this warning: at net/core/skbuff.c:4174
and before commit a44878d10063 ("IB/ipoib: Use one linear skb in RX flow")
skb truesize was not being set when ipoib was using just one skb. 
Removing this line avoids the warning when running tcp tests like iperf. 

Fixes: a44878d10063 ("IB/ipoib: Use one linear skb in RX flow")
Signed-off-by: Carol L Soto <clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 5ea0c14..fa9c42f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -245,8 +245,6 @@ static void ipoib_ib_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 	skb_reset_mac_header(skb);
 	skb_pull(skb, IPOIB_ENCAP_LEN);
 
-	skb->truesize = SKB_TRUESIZE(skb->len);
-
 	++dev->stats.rx_packets;
 	dev->stats.rx_bytes += skb->len;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
