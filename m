From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC/PATCH v2] IPoIB: Leave space in skb linear buffer for IP headers
Date: Mon, 8 Apr 2013 09:50:46 -0700
Message-ID: <CAG4TOxMTDM9h8GWoSVj0EB=BLz41muYrGWgfEC0Aps3oCG98pg@mail.gmail.com>
References: <1365109940-22916-1-git-send-email-roland@kernel.org>
 <CD84E1B9.5721%markus.stockhausen@gmx.de> <CAL1RGDWrNpExCzMSORfF74pp4EN_gi==O9nEspU-gwx_z6dNCg@mail.gmail.com>
 <CAL1RGDX=8pcBm-jsAbObW3kHPvaA4S4XydMOSmFahc9zu6tuFg@mail.gmail.com> <CANn89iL358oFA8iGbYZLA30us-4BmvZauRr+_OnJJ2FxqpGF7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANn89iL358oFA8iGbYZLA30us-4BmvZauRr+_OnJJ2FxqpGF7Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 8, 2013 at 9:44 AM, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> Am empty page in the frag list ? You mean a frag with a zero length ?

Yep... the code would do

    skb_fill_page_desc(skb, 0, page, 0, PAGE_SIZE);

but then later on it did the equivalent of

    skb_frag_size_set(frag, 0);
    skb->truesize += PAGE_SIZE;

and somehow when data is flowing both directions with small packets,
that would lead the RX-side handling to return corrupt data to
userspace.

Not sure if it's worth figuring this out entirely ... the more
efficient way for ipoib to do things is to reuse that page for next
time, not pass it up the stack unused.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
