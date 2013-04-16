From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC/PATCH v4] IPoIB: Leave space in skb linear buffer for IP headers
Date: Tue, 16 Apr 2013 10:03:59 -0700
Message-ID: <CAG4TOxNveY5rXnZWO=hn-FuKB0aVO2-Jevxehwx+fr=aXuL2UA@mail.gmail.com>
References: <1366129801-29234-1-git-send-email-roland@kernel.org> <CANn89iK9Z7i59+pHXAXJzgYZxKB6OptR-+TRwfjTqNwHMLDOow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANn89iK9Z7i59+pHXAXJzgYZxKB6OptR-+TRwfjTqNwHMLDOow-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 16, 2013 at 9:56 AM, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> I am afraid I don't understand what the issue is.
>
> the pull_tail() in itself is not a performance issue : Intel guys only
> fixed last gays ago fact that IGB/IXGBE drivers were not pulling tcp
> headers in skb->head , and nobody noticed.
>
> Real cost is the cache line miss.

According to Markus there is a pretty huge performance penalty if the
whole packet (TCP/IP headers + payload) ends up in the fragment, and
stack has to memcpy headers into the linear part.

> Now, if you pull too many bytes in skb->head, say part of TCP payload,
> you lose opportunities in TCP coalescing or splice().

So it sounds like this patch is a bad change from that POV, since it
would cause us to have lots of TCP payload in the linear part and then
second half of the payload in the fragments (if we are running with 4K
IPoIB MTU).

Seems like the real fix is to enable the header separation feature in
adapters that support it (ConnectX-2 and -3) so that exactly TCP/IP
headers go in linear part and payload goes in the fragment.  That's a
bit more involved, but I'll look into doing it.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
