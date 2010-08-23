From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: IPoIB: Broken IGMP processing
Date: Mon, 23 Aug 2010 12:16:40 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1008231210010.9840@router.home>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Yossi Etigin <yosefe-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We see that IGMP timers are not properly deferred when hosts send IGMP
membership information. It looks as if the IPoIB layer does not properly
mark the multicast/broadcast packets with PACKET_MULTICAST or
PACKET_BROADCAST. As a results icmp_recv() ignores the IGMP membership
information from others. That in turn results in the IGMP timers
frequently expiring, thus the network becomes quite chatty.

The following is an untested patch: I am not sure how exact to access the
ipob Mac header. The IB header contains a special marker for IPoIB
multicast. So it should be simple to identify the multicast packets in the
receive path.


Subject: [IB] Make igmp processing work with IPOIB

IGMP processing is broken because the IPOIB does not set the
skb->pkt_type the right way for Multicast traffic. All incoming
packets are set to PACKET_HOST which means that the igmp_recv()
function will ignore the IGMP broadcasts/multicasts.

This in turn means that the IGMP timers are firing and are sending
information about multicast subscriptions unnecessarily. In a large
private network this can cause traffic spikes.

Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

---
 drivers/infiniband/ulp/ipoib/ipoib.h    |   13 +++++++++++++
 drivers/infiniband/ulp/ipoib/ipoib_ib.c |    6 ++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/infiniband/ulp/ipoib/ipoib.h
===================================================================
--- linux-2.6.orig/drivers/infiniband/ulp/ipoib/ipoib.h	2010-08-20 19:44:13.000000000 -0500
+++ linux-2.6/drivers/infiniband/ulp/ipoib/ipoib.h	2010-08-20 19:58:21.000000000 -0500
@@ -114,6 +114,9 @@ enum {
 #define	IPOIB_OP_CM     (0)
 #endif

+#define IPOIB_MGID_IPV4_SIGNATURE 0x401B
+#define IPOIB_MGID_IPV6_SIGNATURE 0x601B
+
 /* structs */

 struct ipoib_header {
@@ -125,6 +128,16 @@ struct ipoib_pseudoheader {
 	u8  hwaddr[INFINIBAND_ALEN];
 };

+int ipoib_is_ipv4_multicast(u8 *p)
+{
+	return *((u16 *)(p + 2)) == htonl(IPOIB_MGID_IPV4_SIGNATURE);
+}
+
+int ipoib_is_ipv6_multicast(u8 *p)
+{
+	return *((u16 *)(p + 2)) == htonl(IPOIB_MGID_IPV6_SIGNATURE);
+}
+
 /* Used for all multicast joins (broadcast, IPv4 mcast and IPv6 mcast) */
 struct ipoib_mcast {
 	struct ib_sa_mcmember_rec mcmember;
Index: linux-2.6/drivers/infiniband/ulp/ipoib/ipoib_ib.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/ulp/ipoib/ipoib_ib.c	2010-08-20 18:43:44.000000000 -0500
+++ linux-2.6/drivers/infiniband/ulp/ipoib/ipoib_ib.c	2010-08-20 19:58:34.000000000 -0500
@@ -281,8 +281,10 @@ static void ipoib_ib_handle_rx_wc(struct
 	dev->stats.rx_bytes += skb->len;

 	skb->dev = dev;
-	/* XXX get correct PACKET_ type here */
-	skb->pkt_type = PACKET_HOST;
+	if (ipoib_is_ipv4_multicast(skb_mac_header(skb)))
+		skb->pkt_type = PACKET_MULTICAST;
+	else
+		skb->pkt_type = PACKET_HOST;

 	if (test_bit(IPOIB_FLAG_CSUM, &priv->flags) && likely(wc->csum_ok))
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
