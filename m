From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: IPoIB header prefetch for fragmented SKB
Date: Wed, 17 Apr 2013 14:49:26 -0700
Message-ID: <CAL1RGDWVOPsEe+92sgcz+fDWj8=02CJt40889_cgsQKBX6XJ4A@mail.gmail.com>
References: <CANn89iLopRHCMhYc+BcPvhZJtfL53H3T6JdP=ssfdg=oxh+Waw@mail.gmail.com>
 <CD94B1E6.588B%markus.stockhausen@gmx.de> <CANn89iLwF9LUohz_c765c4b+6DC0gTH77bN5QzbAkR-4LCcUog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANn89iLwF9LUohz_c765c4b+6DC0gTH77bN5QzbAkR-4LCcUog-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 17, 2013 at 12:10 PM, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> +               prefetch(page_address(frag->page.p));

I guess we would have to change our allocation to __get_free_page()
(instead of alloc_page()), so that we make sure never to get a highmem
page?

Other than that, seems fine.

By the way, is there any value to header splitting -- having the
adapter put the TCP/IP headers in the linear part and the payload in
the fragment page?  How about in the case where we have a small enough
MTU that we could put the whole packet in the linear part?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
