From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: IPoIB: Broken IGMP processing
Date: Mon, 23 Aug 2010 13:10:45 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1008231254300.10719@router.home>
References: <alpine.DEB.2.00.1008231210010.9840@router.home> <20100823174110.GK26549@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100823174110.GK26549-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Yossi Etigin <yosefe-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 23 Aug 2010, Jason Gunthorpe wrote:

> On Mon, Aug 23, 2010 at 12:16:40PM -0500, Christoph Lameter wrote:
>
> > +int ipoib_is_ipv4_multicast(u8 *p)
> > +{
> > +	return *((u16 *)(p + 2)) == htonl(IPOIB_MGID_IPV4_SIGNATURE);
> > +}
> > +
> > +int ipoib_is_ipv6_multicast(u8 *p)
> > +{
> > +	return *((u16 *)(p + 2)) == htonl(IPOIB_MGID_IPV6_SIGNATURE);
> > +}
>
> static inline for functions in headers?

Right.

> Maybe checking for checking wc->qp_num == multicast QPN is a better
> choice?

If that is properly set then yes of course that is much easier. Would this
work? The broadcast QP is used for multicast right?


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
 drivers/infiniband/ulp/ipoib/ipoib_ib.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/infiniband/ulp/ipoib/ipoib_ib.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/ulp/ipoib/ipoib_ib.c	2010-08-23 13:07:32.000000000 -0500
+++ linux-2.6/drivers/infiniband/ulp/ipoib/ipoib_ib.c	2010-08-23 13:09:06.000000000 -0500
@@ -223,6 +223,7 @@ static void ipoib_ib_handle_rx_wc(struct
 	unsigned int wr_id = wc->wr_id & ~IPOIB_OP_RECV;
 	struct sk_buff *skb;
 	u64 mapping[IPOIB_UD_RX_SG];
+	struct ipoib_dev_priv *multicast_priv = netdev_priv(priv->broadcast->dev);

 	ipoib_dbg_data(priv, "recv completion: id %d, status: %d\n",
 		       wr_id, wc->status);
@@ -281,8 +282,11 @@ static void ipoib_ib_handle_rx_wc(struct
 	dev->stats.rx_bytes += skb->len;

 	skb->dev = dev;
-	/* XXX get correct PACKET_ type here */
-	skb->pkt_type = PACKET_HOST;
+	if (wc->src_qp == multicast_priv->qp->qp_num)
+
+		skb->pkt_type = PACKET_MULTICAST;
+	else
+		skb->pkt_type = PACKET_HOST;

 	if (test_bit(IPOIB_FLAG_CSUM, &priv->flags) && likely(wc->csum_ok))
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
