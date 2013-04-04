From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [RFC/PATCH v2] IPoIB: Leave space in skb linear buffer for IP headers
Date: Thu,  4 Apr 2013 14:12:20 -0700
Message-ID: <1365109940-22916-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org> noticed that IPoIB was
spending significant time doing memcpy() in __pskb_pull_tail().  He
found that this is because his adapter reports a maximum MTU of 4K,
which causes IPoIB datagram mode to receive all the actual data in a
separate page in the fragment list.

We're already allocating extra tailroom for the skb linear part, so we
might as well use it.

Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Reported-by: Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
v2: Try to handle the case where we get all the data in the linear part
of the skb and don't need the frag part at all.

 drivers/infiniband/ulp/ipoib/ipoib.h    |  3 ++-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c | 17 ++++++-----------
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index eb71aaa..ab2cc4c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -64,7 +64,8 @@ enum ipoib_flush_level {
 enum {
 	IPOIB_ENCAP_LEN		  = 4,
 
-	IPOIB_UD_HEAD_SIZE	  = IB_GRH_BYTES + IPOIB_ENCAP_LEN,
+	/* add 128 bytes of tailroom for IP/TCP headers */
+	IPOIB_UD_HEAD_SIZE	  = IB_GRH_BYTES + IPOIB_ENCAP_LEN + 128,
 	IPOIB_UD_RX_SG		  = 2, /* max buffer needed for 4K mtu */
 
 	IPOIB_CM_MTU		  = 0x10000 - 0x10, /* padding to align header to 16 */
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 2cfa76f..ecf4faf 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -109,11 +109,12 @@ static void ipoib_ud_skb_put_frags(struct ipoib_dev_priv *priv,
 				   struct sk_buff *skb,
 				   unsigned int length)
 {
-	if (ipoib_ud_need_sg(priv->max_ib_mtu)) {
+	if (ipoib_ud_need_sg(priv->max_ib_mtu) &&
+	    length > IPOIB_UD_HEAD_SIZE) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[0];
 		unsigned int size;
 		/*
-		 * There is only two buffers needed for max_payload = 4K,
+		 * There are only two buffers needed for max_payload = 4K,
 		 * first buf size is IPOIB_UD_HEAD_SIZE
 		 */
 		skb->tail += IPOIB_UD_HEAD_SIZE;
@@ -156,18 +157,12 @@ static struct sk_buff *ipoib_alloc_rx_skb(struct net_device *dev, int id)
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct sk_buff *skb;
 	int buf_size;
-	int tailroom;
 	u64 *mapping;
 
-	if (ipoib_ud_need_sg(priv->max_ib_mtu)) {
-		buf_size = IPOIB_UD_HEAD_SIZE;
-		tailroom = 128; /* reserve some tailroom for IP/TCP headers */
-	} else {
-		buf_size = IPOIB_UD_BUF_SIZE(priv->max_ib_mtu);
-		tailroom = 0;
-	}
+	buf_size = ipoib_ud_need_sg(priv->max_ib_mtu) ?
+		IPOIB_UD_HEAD_SIZE : IPOIB_UD_BUF_SIZE(priv->max_ib_mtu);
 
-	skb = dev_alloc_skb(buf_size + tailroom + 4);
+	skb = dev_alloc_skb(buf_size + 4);
 	if (unlikely(!skb))
 		return NULL;
 
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
