From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC/PATCH v2] IPoIB: Leave space in skb linear buffer for IP headers
Date: Mon, 8 Apr 2013 15:04:38 -0700
Message-ID: <CAG4TOxO8bT7LjeeXiRN=9cYUZsCvmg2wfMtnvnUA_VJB41HzNw@mail.gmail.com>
References: <CAG4TOxMTDM9h8GWoSVj0EB=BLz41muYrGWgfEC0Aps3oCG98pg@mail.gmail.com>
 <CD88DFB5.577C%markus.stockhausen@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CD88DFB5.577C%markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 8, 2013 at 12:03 PM, Markus Stockhausen
<markus.stockhausen-Mmb7MZpHnFY@public.gmane.org> wrote:
> First I thought perfect memory allocation inside ipoib_alloc_rx_skb()
> could be realized by passing the received packet size from function
> ipoib_ib_handle_rx_wc(). But I'm unable to estimate the requirements
> of the similar call inside ipoib_ib_post_receives().

The problem is that we have to allocate the receive buffer before we
know how big the packet we're going to receive is.

Anyway, see my latest patch.  I'm pretty sure it should work -- and I
hope the performance is reasonable.  Your approach of hacking the max
mtu avoids the fragmented skb completely, whereas I'm just making sure
the TCP/IP headers are in the linear part.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
