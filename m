From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC/PATCH v3] IPoIB: Leave space in skb linear buffer for IP headers
Date: Tue, 16 Apr 2013 09:30:57 -0700
Message-ID: <CAG4TOxMguvWUji7s-NtAq6iDr12h7sx8SrRBW0JGyrjfW8qXBw@mail.gmail.com>
References: <CAL1RGDURSq9bfS5M-+f-zELapJWVWnwQ3Z=Ga_Wfj0s_H1Mn_w@mail.gmail.com>
 <CD934227.5829%markus.stockhausen@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CD934227.5829%markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 16, 2013 at 9:22 AM, Markus Stockhausen
<markus.stockhausen-Mmb7MZpHnFY@public.gmane.org> wrote:
> if I think about the current situation we can make it only better.
> When receiving a packet on a 4K HCA we have to pull the IP header
> into the linear part of the SKB during GRO handling. That consumes
> extra CPU cycles and does not depend on the packet size.
>
> We can avoid this by splitting the packet at a well defined position.
> Your patch made a cut at x+128 bytes. From my understanding the
> position should have no performance impact. The 3 cases that we
> analyzed up to now are:
>
> - 2K fragment + header pull = fast
> - header and some data in linear part + 1,9K fragment = faster
> - only linear part + no fragment = fastest
>
> Maybe I'm too hasty (without a 4K MTU test environment) but from
> the above I would derive that larger packets will still benefit
> from the adapted handling.

Yes, makes sense to me as well.  I sent a v4 patch that I'm pretty
sure should work well for you.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
