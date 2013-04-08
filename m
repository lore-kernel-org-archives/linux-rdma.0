From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC/PATCH v2] IPoIB: Leave space in skb linear buffer for IP headers
Date: Mon, 8 Apr 2013 08:59:09 -0700
Message-ID: <CAL1RGDX=8pcBm-jsAbObW3kHPvaA4S4XydMOSmFahc9zu6tuFg@mail.gmail.com>
References: <1365109940-22916-1-git-send-email-roland@kernel.org>
 <CD84E1B9.5721%markus.stockhausen@gmx.de> <CAL1RGDWrNpExCzMSORfF74pp4EN_gi==O9nEspU-gwx_z6dNCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWrNpExCzMSORfF74pp4EN_gi==O9nEspU-gwx_z6dNCg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 5, 2013 at 1:44 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Thanks.  I guess I'll have to set up a testbed and debug this myself.
> I'll try to work on that this weekend.

So I was able to reproduce the problem (or at least a problem) with
netpipe.  Doing "NPtcp -i -2" hit bad data pretty quickly (where the
receiver didn't get the same data as the sender sent).

It turns out that the problem is with packets that don't go into the
fragment page ... with my patch applied, ipoib sends skbs up the stack
that have an empty page in the fragment list, and this apparently
messes something up in the TCP/IP code.

I have a hacky version that clears the frag list if the page isn't
used, and that seems to work fine.  However I want to clean it up; I
should have a good version later today.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
