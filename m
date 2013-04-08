From: Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [RFC/PATCH v2] IPoIB: Leave space in skb linear buffer for IP
 headers
Date: Mon, 08 Apr 2013 21:03:16 +0200
Message-ID: <CD88DFB5.577C%markus.stockhausen@gmx.de>
References: <CAG4TOxMTDM9h8GWoSVj0EB=BLz41muYrGWgfEC0Aps3oCG98pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxMTDM9h8GWoSVj0EB=BLz41muYrGWgfEC0Aps3oCG98pg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Am 08.04.13 18:50 schrieb "Roland Dreier" unter <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:

>On Mon, Apr 8, 2013 at 9:44 AM, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> Am empty page in the frag list ? You mean a frag with a zero length ?
>
>Yep... the code would do
>
>    skb_fill_page_desc(skb, 0, page, 0, PAGE_SIZE);
>
>but then later on it did the equivalent of
>
>    skb_frag_size_set(frag, 0);
>    skb->truesize += PAGE_SIZE;
>
>and somehow when data is flowing both directions with small packets,
>that would lead the RX-side handling to return corrupt data to
>userspace.
>
>Not sure if it's worth figuring this out entirely ... the more
>efficient way for ipoib to do things is to reuse that page for next
>time, not pass it up the stack unused.
>
> - R.

First I thought perfect memory allocation inside ipoib_alloc_rx_skb()
could be realized by passing the received packet size from function
ipoib_ib_handle_rx_wc(). But I'm unable to estimate the requirements
of the similar call inside ipoib_ib_post_receives().

Nevertheless thank you very much for spending time on this.

Markus


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
