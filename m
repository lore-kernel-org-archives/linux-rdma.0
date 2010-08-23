From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: IPoIB: Broken IGMP processing
Date: Mon, 23 Aug 2010 11:41:10 -0600
Message-ID: <20100823174110.GK26549@obsidianresearch.com>
References: <alpine.DEB.2.00.1008231210010.9840@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008231210010.9840-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Yossi Etigin <yosefe-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 23, 2010 at 12:16:40PM -0500, Christoph Lameter wrote:

> +int ipoib_is_ipv4_multicast(u8 *p)
> +{
> +	return *((u16 *)(p + 2)) == htonl(IPOIB_MGID_IPV4_SIGNATURE);
> +}
> +
> +int ipoib_is_ipv6_multicast(u8 *p)
> +{
> +	return *((u16 *)(p + 2)) == htonl(IPOIB_MGID_IPV6_SIGNATURE);
> +}

static inline for functions in headers?

> +
>  /* Used for all multicast joins (broadcast, IPv4 mcast and IPv6 mcast) */
>  struct ipoib_mcast {
>  	struct ib_sa_mcmember_rec mcmember;
> Index: linux-2.6/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> ===================================================================
> +++ linux-2.6/drivers/infiniband/ulp/ipoib/ipoib_ib.c	2010-08-20 19:58:34.000000000 -0500
> @@ -281,8 +281,10 @@ static void ipoib_ib_handle_rx_wc(struct
>  	dev->stats.rx_bytes += skb->len;
> 
>  	skb->dev = dev;
> -	/* XXX get correct PACKET_ type here */
> -	skb->pkt_type = PACKET_HOST;
> +	if (ipoib_is_ipv4_multicast(skb_mac_header(skb)))
> +		skb->pkt_type = PACKET_MULTICAST;
> +	else
> +		skb->pkt_type = PACKET_HOST;
> 
>  	if (test_bit(IPOIB_FLAG_CSUM, &priv->flags) && likely(wc->csum_ok))
>  		skb->ip_summed = CHECKSUM_UNNECESSARY;

Hmmm... What are you trying to access here? I'm guessing it is the
DGID of the GRH?

        ipoib_ud_skb_put_frags(priv, skb, wc->byte_len);
        skb_pull(skb, IB_GRH_BYTES);  <-- These are the bytes you want
        skb_reset_mac_header(skb);  <-- Sets skb_mac_header to skb->head+40
        skb_pull(skb, IPOIB_ENCAP_LEN);

So, I think you are accessing byte 42, which doesn't seem right? The
DGID starts in byte 24 from skb->head.

Also, you need to check for IBV_WC_GRH, the 40 bytes are garbage if it
is not set.

Maybe checking for checking wc->qp_num == multicast QPN is a better
choice?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
