From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: IB/qib, staging/rdma/hfi1: add s_hlock for use in post send
Date: Wed, 23 Mar 2016 20:51:29 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC25A8BA74@fmsmsx120.amr.corp.intel.com>
References: <20160322200322.GA27995@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160322200322.GA27995@mwanda>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Hello Mike Marciniszyn,
> 
> The patch 46a80d62e6e0: "IB/qib, staging/rdma/hfi1: add s_hlock for use in
> post send" from Feb 14, 2016, leads to the following static checker warning:
> 
> 	drivers/infiniband/hw/qib/qib_ud.c:395 qib_make_ud_req()
> 	warn: 'irqsave:flags' is sometimes locked here and sometimes
> unlocked.
> 
> drivers/infiniband/hw/qib/qib_ud.c
>    293          } else {
>    294                  this_cpu_inc(ibp->pmastats->n_unicast_xmit);
>    295                  lid = ah_attr->dlid & ~((1 << ppd->lmc) - 1);
>    296                  if (unlikely(lid == ppd->lid)) {
>    297                          unsigned long flags;
>                                               ^^^^^
>    298                          /*
>    299                           * If DMAs are in progress, we can't generate
>    300                           * a completion for the loopback packet since
>    301                           * it would be out of order.
>    302                           * XXX Instead of waiting, we could queue a
>    303                           * zero length descriptor so we get a callback.
>    304                           */
>    305                          if (atomic_read(&priv->s_dma_busy)) {
>    306                                  qp->s_flags |= RVT_S_WAIT_DMA;
>    307                                  goto bail;
>    308                          }
>    309                          qp->s_cur = next_cur;
>    310                          local_irq_save(flags);
>                                 ^^^^^^^^^^^^^^^^^^^^^
>    311                          spin_unlock_irqrestore(&qp->s_lock, flags);
>                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Complicated no-op with the IRQ flags.
> 
>    312                          qib_ud_loopback(qp, wqe);
>    313                          spin_lock_irqsave(&qp->s_lock, flags);
>                                                                ^^^^^ We save the flags but then we leave
> the scope without using them.
> 

Dan,

I'm currently working on a fix for this.

Thanks for the report!
Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
