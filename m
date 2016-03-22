From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: IB/qib, staging/rdma/hfi1: add s_hlock for use in post send
Date: Tue, 22 Mar 2016 23:03:23 +0300
Message-ID: <20160322200322.GA27995@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Mike Marciniszyn,

The patch 46a80d62e6e0: "IB/qib, staging/rdma/hfi1: add s_hlock for
use in post send" from Feb 14, 2016, leads to the following static
checker warning:

	drivers/infiniband/hw/qib/qib_ud.c:395 qib_make_ud_req()
	warn: 'irqsave:flags' is sometimes locked here and sometimes unlocked.

drivers/infiniband/hw/qib/qib_ud.c
   293          } else {
   294                  this_cpu_inc(ibp->pmastats->n_unicast_xmit);
   295                  lid = ah_attr->dlid & ~((1 << ppd->lmc) - 1);
   296                  if (unlikely(lid == ppd->lid)) {
   297                          unsigned long flags;
                                              ^^^^^
   298                          /*
   299                           * If DMAs are in progress, we can't generate
   300                           * a completion for the loopback packet since
   301                           * it would be out of order.
   302                           * XXX Instead of waiting, we could queue a
   303                           * zero length descriptor so we get a callback.
   304                           */
   305                          if (atomic_read(&priv->s_dma_busy)) {
   306                                  qp->s_flags |= RVT_S_WAIT_DMA;
   307                                  goto bail;
   308                          }
   309                          qp->s_cur = next_cur;
   310                          local_irq_save(flags);
                                ^^^^^^^^^^^^^^^^^^^^^
   311                          spin_unlock_irqrestore(&qp->s_lock, flags);
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Complicated no-op with the IRQ flags.

   312                          qib_ud_loopback(qp, wqe);
   313                          spin_lock_irqsave(&qp->s_lock, flags);
                                                               ^^^^^
We save the flags but then we leave the scope without using them.

   314                          qib_send_complete(qp, wqe, IB_WC_SUCCESS);
   315                          goto done;
   316                  }
   317          }

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
