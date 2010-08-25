From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: RE: IPoIB: Broken IGMP processing
Date: Wed, 25 Aug 2010 09:43:45 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1008250943230.15571@router.home>
References: <alpine.DEB.2.00.1008231427130.12815@router.home><7E95F01E94AB484F83061FCFA35B39F8013249@exil.voltaire.com> <20100823194555.GN26549@obsidianresearch.com> <7E95F01E94AB484F83061FCFA35B39F801324A@exil.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7E95F01E94AB484F83061FCFA35B39F801324A-QfUkFaTmzUSUvQqKE/ONIwC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yossi Etigin <yosefe-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 23 Aug 2010, Yossi Etigin wrote:

> >
> > Simplest then is to check if byte 24 of the packet is 0xff.
> > (ie IN6_IS_ADDR_MULTICAST)
> >
> > No need to worry about if it is properly formed or anything, if it is
> > a multicast DGID then it is a multicast packet at the link level.
> >
>
> Sounds good to me

Therefore this patch?

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
 drivers/infiniband/ulp/ipoib/ipoib_ib.c |    7 +++++--
 include/linux/in6.h                     |    3 +++
 2 files changed, 8 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/infiniband/ulp/ipoib/ipoib_ib.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/ulp/ipoib/ipoib_ib.c	2010-08-23 16:04:38.000000000 -0500
+++ linux-2.6/drivers/infiniband/ulp/ipoib/ipoib_ib.c	2010-08-25 09:43:01.000000000 -0500
@@ -281,8 +281,11 @@ static void ipoib_ib_handle_rx_wc(struct
 	dev->stats.rx_bytes += skb->len;

 	skb->dev = dev;
-	/* XXX get correct PACKET_ type here */
-	skb->pkt_type = PACKET_HOST;
+	if (IN6_IS_ADDR_MULTICAST(skb->head + 24))
+
+		skb->pkt_type = PACKET_MULTICAST;
+	else
+		skb->pkt_type = PACKET_HOST;

 	if (test_bit(IPOIB_FLAG_CSUM, &priv->flags) && likely(wc->csum_ok))
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
Index: linux-2.6/include/linux/in6.h
===================================================================
--- linux-2.6.orig/include/linux/in6.h	2010-08-25 09:39:40.000000000 -0500
+++ linux-2.6/include/linux/in6.h	2010-08-25 09:40:22.000000000 -0500
@@ -53,6 +53,9 @@ extern const struct in6_addr in6addr_lin
 extern const struct in6_addr in6addr_linklocal_allrouters;
 #define IN6ADDR_LINKLOCAL_ALLROUTERS_INIT \
 		{ { { 0xff,2,0,0,0,0,0,0,0,0,0,0,0,0,0,2 } } }
+
+#define IN6_IS_ADDR_MULTICAST(a) (((const __u8 *) (a))[0] == 0xff)
+
 #endif

 struct sockaddr_in6 {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
