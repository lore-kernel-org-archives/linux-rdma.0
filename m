From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/2] IB/cm: Fix sleeping in atomic when RoCE is used
Date: Tue, 29 Aug 2017 18:37:13 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB18D9B0@ORSMSX109.amr.corp.intel.com>
References: <20170829173444.4289-1-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170829173444.4289-1-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> 
> A couple of places in the CM do
> 
>     spin_lock_irq(&cm_id_priv->lock);
>     ...
>     if (cm_alloc_response_msg(work->port, work->mad_recv_wc, &msg))
> 
> However when the underlying transport is RoCE, this leads to a
> sleeping function being called with the lock held - the callchain is
> 
>     cm_alloc_response_msg() ->
>       ib_create_ah_from_wc() ->
>         ib_init_ah_from_wc() ->
>           rdma_addr_find_l2_eth_by_grh() ->
>             rdma_resolve_ip()
> 
> and rdma_resolve_ip() starts out by doing
> 
>     req = kzalloc(sizeof *req, GFP_KERNEL);
> 
> not to mention rdma_addr_find_l2_eth_by_grh() doing
> 
>     wait_for_completion(&ctx.comp);
> 
> to wait for the task that rdma_resolve_ip() queues up.
> 
> Fix this by moving the AH creation out of the lock.
> 
> Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
