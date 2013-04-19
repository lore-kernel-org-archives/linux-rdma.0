From: Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: IPoIB header prefetch for fragmented SKB
Date: Fri, 19 Apr 2013 20:07:12 +0200
Message-ID: <CD975158.5900%markus.stockhausen@gmx.de>
References: <CANn89iLwF9LUohz_c765c4b+6DC0gTH77bN5QzbAkR-4LCcUog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANn89iLwF9LUohz_c765c4b+6DC0gTH77bN5QzbAkR-4LCcUog-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Am 17.04.13 21:10 schrieb "Eric Dumazet" unter <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>:

>Please try :
>
>diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
>b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
>index 2cfa76f..9bdff21 100644
>--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
>+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
>@@ -112,6 +112,8 @@ static void ipoib_ud_skb_put_frags(struct
>ipoib_dev_priv *priv,
>        if (ipoib_ud_need_sg(priv->max_ib_mtu)) {
>                skb_frag_t *frag = &skb_shinfo(skb)->frags[0];
>                unsigned int size;
>+
>+               prefetch(page_address(frag->page.p));
>                /*
>                 * There is only two buffers needed for max_payload = 4K,
>                 * first buf size is IPOIB_UD_HEAD_SIZE

Thanks to both of you for spending time on this.

Sorry to tell you that the above patch does not give any performance
improvements. So I put a debug message inside inside pskb_may_pull()
just in front of __pskb_pull_tail() to give an idea what happens.

During a netserver/netperf run with an MTU of 2044 bytes I can read
the following repeating messages:

[   52.909805] 0 bytes inline, 1988 bytes in fragment, pull 20 bytes
[   52.909807] 20 bytes inline, 1968 bytes in fragment, pull 40 bytes
[   52.909809] 40 bytes inline, 1948 bytes in fragment, pull 52 bytes
[   52.909812] 0 bytes inline, 1988 bytes in fragment, pull 20 bytes
[   52.909814] 20 bytes inline, 1968 bytes in fragment, pull 40 bytes
[   52.909816] 40 bytes inline, 1948 bytes in fragment, pull 52 bytes


Now I'm getting lost somehow. From 2044 bytes 1988 are left in the
fragment and 112 have to be pulled into the linear part. This is
achieved by 3 steps. So we are far beyond the cache line size of 64
bytes.

Any ideas?

Markus


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
