From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: IPoIB - GRO forces memcpy inside __pskb_pull_tail
Date: Thu, 4 Apr 2013 11:10:31 -0700
Message-ID: <CAL1RGDWw+K_hCBjQ36KmHwSTg0kEobsLRY3wEGTSPgpc3zEqjw@mail.gmail.com>
References: <CAJZOPZ+7mvjgjhm2d7fpN=PE0ste3jJQyyN0vKdSAG3zWA9yYg@mail.gmail.com>
 <CD8245B7.5691%markus.stockhausen@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CD8245B7.5691%markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 3, 2013 at 12:03 PM, Markus Stockhausen
<markus.stockhausen-Mmb7MZpHnFY@public.gmane.org> wrote:
> going through hard lessons to understand the SKBs maybe I finally
> found the reason for the unnecessary memcpy commands. Even with
> newest 3.9-rc5 kernel the problem persists. IPoIB creates only
> fragmented SKBs without any single bit in the normal data part. Some
> debug messages during GRO handling showed
>
> skb->len         = 1988 (total data)
> skb->data_len    = 1988 (paged data)
> skb_headlen(skb) = 0    (non paged data)
>
> inet_gro_receive() requires the IP header inside the SKB. So it
> pulls missing data from fragments. This process requires extra
> memcpy operations.

Thanks for the really detailed investigation!  This makes sense.

I'll send out a proposed patch for you to test in a moment.

Thanks!
  Roland
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
