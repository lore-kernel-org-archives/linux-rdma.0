From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC for-next] net/mlx4_core: Fix racy flow in the driver
 CQ completion handler
Date: Thu, 30 Aug 2012 15:35:58 -0700
Message-ID: <CAL1RGDX7kx7aypOqYvvwu8KBjMra2Gqq+4OGLz22k0RVmeZ1eQ@mail.gmail.com>
References: <1346323085-2665-1-git-send-email-ogerlitz@mellanox.com> <CAJZOPZJOWuoBQx49-O2WLk240GWGRsqfJpCXfhxRV6Cmdw7W0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJOWuoBQx49-O2WLk240GWGRsqfJpCXfhxRV6Cmdw7W0w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 30, 2012 at 3:17 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> Roland Dreier =E2=80=8E<roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>  wrote:
>
>> Can you be explicit about the race you're worried about?
>
> few
>
> 1. on the  time CQ A is deleted an interrupt that relates to CQ B
> takes place and a radix
> tree lookup is running while an element is being deleted from the
> tree, looking on the radix tree API, I don't see that this is allowed=
=2E

I don't think this is a real problem; the radix tree code is
explicitly designed for RCU use, and the data structure is pretty
clearly safe for looking up one slot while another slot is being
cleared.  In fact it's hard to see how this could screw up.

> 2. while a CQ is being freed an interrupt takes place and the driver
> attempts to run the comp handler which can turn to use after free,
> null pointer deref, etc. This can happen even if the ULP made sure to
> consume all the WCs related to flushed/etc, e.g an "empty"
> interrupt

So in mlx4_cq_free() we do

        mlx4_HW2SW_CQ(dev, NULL, cq->cqn);
        //...
        synchronize_irq(priv->eq_table.eq[cq->vector].irq);

before we touch the cq table.  I don't think we should get a CQ
completion event for the CQ we're freeing after we've done HW2SW_CQ on
it and then waited for any outstanding completion interrupts to
finish.

Also we know that there are no QPs attached to this CQ so there
shouldn't be any completion events anyway...

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
