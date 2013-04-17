From: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: IPoIB header prefetch for fragmented SKB
Date: Wed, 17 Apr 2013 12:10:29 -0700
Message-ID: <CANn89iLwF9LUohz_c765c4b+6DC0gTH77bN5QzbAkR-4LCcUog@mail.gmail.com>
References: <CANn89iLopRHCMhYc+BcPvhZJtfL53H3T6JdP=ssfdg=oxh+Waw@mail.gmail.com>
	<CD94B1E6.588B%markus.stockhausen@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CD94B1E6.588B%markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Please try :

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 2cfa76f..9bdff21 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -112,6 +112,8 @@ static void ipoib_ud_skb_put_frags(struct
ipoib_dev_priv *priv,
        if (ipoib_ud_need_sg(priv->max_ib_mtu)) {
                skb_frag_t *frag = &skb_shinfo(skb)->frags[0];
                unsigned int size;
+
+               prefetch(page_address(frag->page.p));
                /*
                 * There is only two buffers needed for max_payload = 4K,
                 * first buf size is IPOIB_UD_HEAD_SIZE

On Wed, Apr 17, 2013 at 11:38 AM, Markus Stockhausen
<markus.stockhausen-Mmb7MZpHnFY@public.gmane.org> wrote:
>>
>>
>>
>>That's probably because of a cache line miss.
>>
>>The thing I don't really understand is that normally, the first cache
>>line (64 bytes) contains both the Ethernet header and IPv4 header.
>>
>>So what does this adapter in this respect ?
>>
>>I guess you should try to use IPOIB_UD_HEAD_SIZE=64 to use the whole
>>cache line.
>>
>>Many drivers use prefetch() to make sure cpu starts to bring this
>>cache line into cache as soon as possible.
>>
>>A single prefetch() call at the right place might help a lot.
>
> Hello,
>
> @Eric: Thanks for the tip.
>
> In the 4K MAX MTU IPoIB driver path ipoib_ib_handle_rx_wc() will
> produce an empty skb linear part with the whole data placed into
> the first fragment. napi_gro_receive() finally pulls the IP
> header out of the fragment into the linear part.
>
> As far as I understand the pull out of the fragment should come
> without additional cost when one calls a prefetch "long" before
> the skb_pull().
>
> I'm willing to check this out but I'm unsure if the IP header
> is aligned to a cache line of 64 bytes. As a simple guess I
> would implement the prefetch here:
>
> static void ipoib_ib_handle_rx_wc();
>   ...
>   skb_pull (skb, IB_GRH_BYTES);
>
>   skb->protocol = ((struct ipoib_header *) skb->data)->proto;
>   skb_reset_mac_header(skb);
>   skb_pull(skb, IPOIB_ENCAP_LEN);
> +
> + if (ipoib_ud_need_sg(priv->max_ib_mtu))
> +   prefetch(<whatever address>);
>   ...
>
> Can you give me a hint what address one should put into the call?
>
> Thanks in advance.
>
> Markus
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
