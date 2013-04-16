From: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC/PATCH v4] IPoIB: Leave space in skb linear buffer for IP headers
Date: Tue, 16 Apr 2013 10:55:21 -0700
Message-ID: <CANn89iLopRHCMhYc+BcPvhZJtfL53H3T6JdP=ssfdg=oxh+Waw@mail.gmail.com>
References: <CANn89iK9Z7i59+pHXAXJzgYZxKB6OptR-+TRwfjTqNwHMLDOow@mail.gmail.com>
	<CD935857.5873%markus.stockhausen@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CD935857.5873%markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 16, 2013 at 10:44 AM, Markus Stockhausen
<markus.stockhausen-Mmb7MZpHnFY@public.gmane.org> wrote:
>
>>I am afraid I don't understand what the issue is.
>>
>>the pull_tail() in itself is not a performance issue : Intel guys only
>>fixed last gays ago fact that IGB/IXGBE drivers were not pulling tcp
>>headers in skb->head , and nobody noticed.
>>
>>Real cost is the cache line miss.
>>
>>Now, if you pull too many bytes in skb->head, say part of TCP payload,
>>you lose opportunities in TCP coalescing or splice().
>
> With patch v4 netperf and NFS receive performance raises to the
> expected values. As I'm no expert in this I can only repost the
> initial performance report that started the whole discussion.
> __pskb_pull_tail consumes a lot time on our XEON L5420 test
> server.
>

That's probably because of a cache line miss.

The thing I don't really understand is that normally, the first cache
line (64 bytes) contains both the Ethernet header and IPv4 header.

So what does this adapter in this respect ?

I guess you should try to use IPOIB_UD_HEAD_SIZE=64 to use the whole cache line.

Many drivers use prefetch() to make sure cpu starts to bring this
cache line into cache as soon as possible.

A single prefetch() call at the right place might help a lot.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
