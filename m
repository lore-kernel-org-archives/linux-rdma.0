From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 05/13] svcrdma: Introduce local rdma_rw API helpers
Date: Thu, 30 Mar 2017 05:30:14 -0700
Message-ID: <20170330123014.GA32364@infradead.org>
References: <20170327132329.5585.98465.stgit@klimt.1015granger.net>
 <20170327134835.5585.76603.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170327134835.5585.76603.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> +	spinlock_t	     sc_rw_ctxt_lock;
> +	struct list_head     sc_rw_ctxts;

It's a little sad that we always need a list and a spinlock when
most requests should need a single context only.

> + * Each WR chain handles a single contiguous server-side buffer,
> + * because some registration modes (eg. FRWR) do not support a
> + * discontiguous scatterlist.

Both FRWR and FMR have no problem with a discontiguous page list,
they only have a problem with any segment but the first not starting
page aligned.  For NFS you'll need vectored direct I/O to hit that
case.

> +	spin_lock(&rdma->sc_rw_ctxt_lock);
> +	if (list_empty(&rdma->sc_rw_ctxts))
> +		goto out_empty;
> +
> +	ctxt = list_first_entry(&rdma->sc_rw_ctxts,
> +				struct svc_rdma_rw_ctxt, rw_list);

Use list_first_entry_or_null?

> +	struct svc_rdma_rw_ctxt *ctxt;
> +
> +	while (!list_empty(&rdma->sc_rw_ctxts)) {
> +		ctxt = list_first_entry(&rdma->sc_rw_ctxts,
> +					struct svc_rdma_rw_ctxt, rw_list);

Same here.


> +	if (wc->status != IB_WC_SUCCESS)
> +		goto flush;
> +
> +out:
> +	rdma_rw_ctx_destroy(&ctxt->rw_ctx, rdma->sc_qp, rdma->sc_port_num,
> +			    ctxt->rw_sg_table.sgl, ctxt->rw_nents,
> +			    DMA_TO_DEVICE);
> +	svc_rdma_put_rw_ctxt(ctxt);
> +	return;
> +
> +flush:
> +	set_bit(XPT_CLOSE, &rdma->sc_xprt.xpt_flags);
> +	if (wc->status != IB_WC_WR_FLUSH_ERR)
> +		pr_err("svcrdma: write ctx: %s (%u/0x%x)\n",
> +		       ib_wc_status_msg(wc->status),
> +		       wc->status, wc->vendor_err);
> +	goto out;

This would seem cleaner without the gotos (but maybe an unlikely
for the if above).

> +	struct svc_xprt *xprt = &rdma->sc_xprt;
> +	struct ib_send_wr *bad_wr;
> +	int ret;
> +
> +	do {
> +		if ((atomic_sub_return(num_wrs, &rdma->sc_sq_avail) > 0)) {

No need for the inner braces.


Except for these minor nitpicks the patch looks fine to me:

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
