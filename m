From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/2] IB/ipoib: fix GRO merge failure for IPoIB originated
 TCP streams
Date: Thu, 26 Jan 2012 16:43:25 +0200
Message-ID: <alpine.LRH.2.00.1201261642340.31408@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1201261624540.30384@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1201261624540.30384-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The GRO flow makes a check in every layer to ensure the packets
are actually merged only if they match at all layers.

The first GRO check, at L2 always fails for IPoIB, since it assumes
that all packets have 14 bytes of Ethernet link layer header. Using the
IPoIB header will not help here either, since its only four bytes. To
overcome this, the skb mac header pointer is set to an area within the
packet IB GRH headroom, such that later, the L2 check done by GRO
succeeds and it can move to checks at the network and transport layers.

Signed-off-by: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 4115be5..89cfaf7 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -228,6 +228,7 @@ static void ipoib_ib_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 	struct sk_buff *skb;
 	u64 mapping[IPOIB_UD_RX_SG];
 	union ib_gid *dgid;
+	unsigned char *psgid;

 	ipoib_dbg_data(priv, "recv completion: id %d, status: %d\n",
 		       wr_id, wc->status);
@@ -286,10 +287,20 @@ static void ipoib_ib_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 	else
 		skb->pkt_type = PACKET_MULTICAST;

-	skb_pull(skb, IB_GRH_BYTES);
+	/*
+	 * GRO first does L2 compares (14 bytes). We must not let it start from
+	 * the IPoIB header as ten octets of the IP header, containing fields
+	 * which vary from packet to packet will cause non-merging of packets.
+	 * from the same TCP stream.
+	 */
+	psgid = skb_pull(skb, offsetof(struct ib_grh, sgid));
+	/* if there's no GRH, that area could contain random data */
+	if (!(wc->wc_flags & IB_WC_GRH))
+		memset(psgid, 0, 16);
+	skb_reset_mac_header(skb);
+	skb_pull(skb, IB_GRH_BYTES - offsetof(struct ib_grh, sgid));

 	skb->protocol = ((struct ipoib_header *) skb->data)->proto;
-	skb_reset_mac_header(skb);
 	skb_pull(skb, IPOIB_ENCAP_LEN);

 	++dev->stats.rx_packets;
-- 
1.6.5.5


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
