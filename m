From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PATCH] rdma/addr: Avoid referencing NULL neighbour
Date: Mon, 18 Jul 2011 11:32:39 -0700 (PDT)
Message-ID: <20110718.113239.1223384296805844957.davem@davemloft.net>
References: <1828884A29C6694DAF28B7E6B8A8237302E759@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237302E759-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date: Mon, 18 Jul 2011 18:29:46 +0000

> Reported by Dave Miller:
> 
> In drivers/infiniband/core/addr.c:
> 
> 	neigh = dst->neighbour;
> 	if (!neigh || !(neigh->nud_state & NUD_VALID)) {
> 		neigh_event_send(dst->neighbour, NULL);
> 		ret = -ENODATA;
> 		goto put;
> 	}
> 
> neigh_event_send() can be passed a NULL pointer, and it will
> OOPS when this happens.
> 
> Avoid passing in a NULL neighbour pointer to neigh_event_send().
> Add checks when resolving both ipv4 and ipv6 addresses.
> 
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
> I added a check to addr4_resolve() as well, but tried to keep the same overall
> logic.  There may be a cleaner way of handling this, but we should at least
> avoid an OOPS in neigh_event_send().

See net-next-2.6, I already took care of this stuff last night during my
neigh layer cleanups.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
