From: Hoang-Nam Nguyen <HNGUYEN-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ehca: use kthread_create_on_node
Date: Fri, 29 Jul 2011 19:39:33 +0200
Message-ID: <OF31C67CA1.9901BC1C-ONC12578DC.0060E598-C12578DC.006101DD@de.ibm.com>
References: <1311923731.7845.25.camel@edumazet-laptop> <CAL1RGDXJzW7e2LTyex1EZXSLBdB_xmcBvBiiS2XKL-5qUCOQ1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXJzW7e2LTyex1EZXSLBdB_xmcBvBiiS2XKL-5qUCOQ1w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,
This patch looks fine to me.
Thanks
Nam

roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org wrote on 29.07.2011 19:10:32:

> [image removed]
>
> Re: [PATCH] IB/ehca: use kthread_create_on_node
>
> Roland Dreier
>
> to:
>
> Eric Dumazet
>
> 29.07.2011 19:11
>
> Sent by:
>
> roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
>
> Cc:
>
> Hoang-Nam Nguyen, Christoph Raisch, Sean Hefty, linux-rdma, linux-kernel
>
> On Fri, Jul 29, 2011 at 12:15 AM, Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
wrote:
> > Since create_comp_task() creates percpu kthread, it makes
> > sense to use kthread_create_on_node() to get proper NUMA affinity for
> > kthread stack.
>
> Seems eminently sane to me.  ehca guys, any concern about this?
>
>  - R.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
