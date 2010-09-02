From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH] [IPOIB] Check for a MTU overflow on the GSO path
Date: Thu, 2 Sep 2010 17:11:40 -0600
Message-ID: <20100902231140.GW24971@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The code to check that the send packet size is less than the MTU
is only invoked in the non-GSO case. This lets packets which are too
large pass through.

Compute the largest packet the GSO operation can produce and check
that against the MTU.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index ec6b4fb..aa9f9cf 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -532,6 +532,7 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 	struct ipoib_tx_buf *tx_req;
 	int hlen, rc;
 	void *phead;
+	unsigned int required_mtu;
 
 	if (skb_is_gso(skb)) {
 		hlen = skb_transport_offset(skb) + tcp_hdrlen(skb);
@@ -543,17 +544,21 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 			dev_kfree_skb_any(skb);
 			return;
 		}
+
+		required_mtu = skb_shinfo(skb)->gso_size + hlen;
 	} else {
-		if (unlikely(skb->len > priv->mcast_mtu + IPOIB_ENCAP_LEN)) {
-			ipoib_warn(priv, "packet len %d (> %d) too long to send, dropping\n",
-				   skb->len, priv->mcast_mtu + IPOIB_ENCAP_LEN);
-			++dev->stats.tx_dropped;
-			++dev->stats.tx_errors;
-			ipoib_cm_skb_too_long(dev, skb, priv->mcast_mtu);
-			return;
-		}
 		phead = NULL;
 		hlen  = 0;
+		required_mtu = skb->len;
+	}
+
+	if (unlikely(required_mtu > priv->mcast_mtu + IPOIB_ENCAP_LEN)) {
+		ipoib_warn(priv, "packet len %d (> %d) too long to send, dropping\n",
+			   required_mtu, priv->mcast_mtu + IPOIB_ENCAP_LEN);
+		++dev->stats.tx_dropped;
+		++dev->stats.tx_errors;
+		ipoib_cm_skb_too_long(dev, skb, priv->mcast_mtu);
+		return;
 	}
 
 	ipoib_dbg_data(priv, "sending packet, length=%d address=%p qpn=0x%06x\n",
-- 
1.5.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
