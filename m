From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC/PATCH v3] IPoIB: Leave space in skb linear buffer for IP headers
Date: Mon, 15 Apr 2013 12:37:36 -0700
Message-ID: <CAL1RGDURSq9bfS5M-+f-zELapJWVWnwQ3Z=Ga_Wfj0s_H1Mn_w@mail.gmail.com>
References: <1365457381-10184-1-git-send-email-roland@kernel.org> <CD8A3957.57AC%markus.stockhausen@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CD8A3957.57AC%markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 9, 2013 at 12:52 PM, Markus Stockhausen
<markus.stockhausen-Mmb7MZpHnFY@public.gmane.org> wrote:
> IPOIB_UD_HEAD_SIZE      = IB_GRH_BYTES + IPOIB_ENCAP_LEN + 3072
>
> In my 2044 MTU case this brings the netperf & NFS throughput to
> the same levels as the dirty hack. Of course this no longer
> reflects a head but equals more or less to something like a
> new constant IPOIB_UD_FIXED_SKB_SIZE.

After thinking about this, I'm pretty convinced that this is probably
a good approach.  However it seems that making IPOIB_UD_HEAD_SIZE be
IB_GRH_BYTES + 2048 should be enough, since that's the size of the
largest receive buffer needed with a 2K IB MTU.

I only wonder what the effect on performance would be with an IB MTU
of 4K active; then full-sized packets would be pretty much exactly
split between the linear part and the fragment page.  How does GRO
cope with that?  I guess in the 2K IB MTU case there's no cost in
having all the data in the linear part of the skb.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
