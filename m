From: Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Subject: IPoIB header prefetch for fragmented SKB
Date: Wed, 17 Apr 2013 20:38:42 +0200
Message-ID: <CD94B1E6.588B%markus.stockhausen@gmx.de>
References: <CANn89iLopRHCMhYc+BcPvhZJtfL53H3T6JdP=ssfdg=oxh+Waw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANn89iLopRHCMhYc+BcPvhZJtfL53H3T6JdP=ssfdg=oxh+Waw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>
>
>
>That's probably because of a cache line miss.
>
>The thing I don't really understand is that normally, the first cache
>line (64 bytes) contains both the Ethernet header and IPv4 header.
>
>So what does this adapter in this respect ?
>
>I guess you should try to use IPOIB_UD_HEAD_SIZE=64 to use the whole
>cache line.
>
>Many drivers use prefetch() to make sure cpu starts to bring this
>cache line into cache as soon as possible.
>
>A single prefetch() call at the right place might help a lot.

Hello,

@Eric: Thanks for the tip.

In the 4K MAX MTU IPoIB driver path ipoib_ib_handle_rx_wc() will
produce an empty skb linear part with the whole data placed into
the first fragment. napi_gro_receive() finally pulls the IP
header out of the fragment into the linear part.

As far as I understand the pull out of the fragment should come
without additional cost when one calls a prefetch "long" before
the skb_pull(). 

I'm willing to check this out but I'm unsure if the IP header
is aligned to a cache line of 64 bytes. As a simple guess I
would implement the prefetch here:

static void ipoib_ib_handle_rx_wc();
  ...
  skb_pull (skb, IB_GRH_BYTES);

  skb->protocol = ((struct ipoib_header *) skb->data)->proto;
  skb_reset_mac_header(skb);
  skb_pull(skb, IPOIB_ENCAP_LEN);
+
+ if (ipoib_ud_need_sg(priv->max_ib_mtu))
+   prefetch(<whatever address>);
  ... 

Can you give me a hint what address one should put into the call?

Thanks in advance.

Markus


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
