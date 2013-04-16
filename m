From: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC/PATCH v4] IPoIB: Leave space in skb linear buffer for IP headers
Date: Tue, 16 Apr 2013 09:56:33 -0700
Message-ID: <CANn89iK9Z7i59+pHXAXJzgYZxKB6OptR-+TRwfjTqNwHMLDOow@mail.gmail.com>
References: <1366129801-29234-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366129801-29234-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 16, 2013 at 9:30 AM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
>
> Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org> noticed that IPoIB was
> spending significant time doing memcpy() in __pskb_pull_tail().  He
> found that this is because his adapter reports a maximum MTU of 4K,
> which causes IPoIB datagram mode to receive all the actual data in a
> separate page in the fragment list.
>
> We're already allocating extra tailroom for the skb linear part, so we
> might as well use it.  In fact, we might as well allocate a big enough
> linear part so that all the data fits there in the relatively common
> case of a 2K IB MTU, and only use a fragment page for 4K IB MTU.
>
> Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Reported-by: Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
> Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> ---
> v4: Leave enough space in linear part of skb so that all data ends up
> there with 2K IB MTU.  Still not sure how this affects perf with a
> 4K IB MTU (should be better since we avoid pulling IP headers out of
> first fragment).
>

I am afraid I don't understand what the issue is.

the pull_tail() in itself is not a performance issue : Intel guys only
fixed last gays ago fact that IGB/IXGBE drivers were not pulling tcp
headers in skb->head , and nobody noticed.

Real cost is the cache line miss.

Now, if you pull too many bytes in skb->head, say part of TCP payload,
you lose opportunities in TCP coalescing or splice().
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
