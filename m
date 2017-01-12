From: Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH v2 25/26] xprtrdma: Inline ib_dma_map_*() functions
Date: Thu, 12 Jan 2017 14:19:40 -0500
Message-ID: <8CC6DD1D-2B3F-4B71-8A2B-0BF08A76AC3E@oracle.com>
References: <20170112190718.6728-1-bart.vanassche@sandisk.com> <20170112190718.6728-26-bart.vanassche@sandisk.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170112190718.6728-26-bart.vanassche@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>
List-Id: linux-rdma@vger.kernel.org


> On Jan 12, 2017, at 2:07 PM, Bart Van Assche <bart.vanassche@sandisk.com> wrote:
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> Cc: Trond Myklebust <trond.myklebust@primarydata.com>
> Cc: Anna Schumaker <anna.schumaker@netapp.com>

Thanks for taking care of this change, Bart.

Patch looks proper, but the svc_rdma* hunks go in a separate patch
to bfields@redhat.com, cc: linux-rdma and linux-nfs.

Reviewed-by: Chuck Lever <chuck.lever@oracle.com>


> ---
> net/sunrpc/xprtrdma/fmr_ops.c              | 12 ++++++------
> net/sunrpc/xprtrdma/frwr_ops.c             | 12 ++++++------
> net/sunrpc/xprtrdma/rpc_rdma.c             | 28 ++++++++++++++--------------
> net/sunrpc/xprtrdma/svc_rdma_backchannel.c |  7 ++++---
> net/sunrpc/xprtrdma/svc_rdma_recvfrom.c    | 20 +++++++++-----------
> net/sunrpc/xprtrdma/svc_rdma_sendto.c      | 26 ++++++++++++++------------
> net/sunrpc/xprtrdma/svc_rdma_transport.c   | 17 +++++++----------
> net/sunrpc/xprtrdma/verbs.c                | 18 ++++++++----------
> 8 files changed, 68 insertions(+), 72 deletions(-)
> 
> diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr_ops.c
> index 1ebb09e1ac4f..debc838e3a6a 100644
> --- a/net/sunrpc/xprtrdma/fmr_ops.c
> +++ b/net/sunrpc/xprtrdma/fmr_ops.c
> @@ -136,8 +136,8 @@ fmr_op_recover_mr(struct rpcrdma_mw *mw)
> 	rc = __fmr_unmap(mw);
> 
> 	/* ORDER: then DMA unmap */
> -	ib_dma_unmap_sg(r_xprt->rx_ia.ri_device,
> -			mw->mw_sg, mw->mw_nents, mw->mw_dir);
> +	dma_unmap_sg(r_xprt->rx_ia.ri_device->dma_device, mw->mw_sg,
> +		     mw->mw_nents, mw->mw_dir);
> 	if (rc)
> 		goto out_release;
> 
> @@ -218,8 +218,8 @@ fmr_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
> 	if (i == 0)
> 		goto out_dmamap_err;
> 
> -	if (!ib_dma_map_sg(r_xprt->rx_ia.ri_device,
> -			   mw->mw_sg, mw->mw_nents, mw->mw_dir))
> +	if (!dma_map_sg(r_xprt->rx_ia.ri_device->dma_device, mw->mw_sg,
> +			mw->mw_nents, mw->mw_dir))
> 		goto out_dmamap_err;
> 
> 	for (i = 0, dma_pages = mw->fmr.fm_physaddrs; i < mw->mw_nents; i++)
> @@ -284,8 +284,8 @@ fmr_op_unmap_sync(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req)
> 	list_for_each_entry_safe(mw, tmp, &req->rl_registered, mw_list) {
> 		list_del_init(&mw->mw_list);
> 		list_del_init(&mw->fmr.fm_mr->list);
> -		ib_dma_unmap_sg(r_xprt->rx_ia.ri_device,
> -				mw->mw_sg, mw->mw_nents, mw->mw_dir);
> +		dma_unmap_sg(r_xprt->rx_ia.ri_device->dma_device,
> +			     mw->mw_sg, mw->mw_nents, mw->mw_dir);
> 		rpcrdma_put_mw(r_xprt, mw);
> 	}
> 
> diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
> index 47bed5333c7f..9b7c604669f9 100644
> --- a/net/sunrpc/xprtrdma/frwr_ops.c
> +++ b/net/sunrpc/xprtrdma/frwr_ops.c
> @@ -182,8 +182,8 @@ frwr_op_recover_mr(struct rpcrdma_mw *mw)
> 
> 	rc = __frwr_reset_mr(ia, mw);
> 	if (state != FRMR_FLUSHED_LI)
> -		ib_dma_unmap_sg(ia->ri_device,
> -				mw->mw_sg, mw->mw_nents, mw->mw_dir);
> +		dma_unmap_sg(ia->ri_device->dma_device, mw->mw_sg, mw->mw_nents,
> +			     mw->mw_dir);
> 	if (rc)
> 		goto out_release;
> 
> @@ -396,8 +396,8 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
> 	if (i == 0)
> 		goto out_dmamap_err;
> 
> -	dma_nents = ib_dma_map_sg(ia->ri_device,
> -				  mw->mw_sg, mw->mw_nents, mw->mw_dir);
> +	dma_nents = dma_map_sg(ia->ri_device->dma_device, mw->mw_sg,
> +			       mw->mw_nents, mw->mw_dir);
> 	if (!dma_nents)
> 		goto out_dmamap_err;
> 
> @@ -538,8 +538,8 @@ frwr_op_unmap_sync(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req)
> 		dprintk("RPC:       %s: DMA unmapping frmr %p\n",
> 			__func__, &mw->frmr);
> 		list_del_init(&mw->mw_list);
> -		ib_dma_unmap_sg(ia->ri_device,
> -				mw->mw_sg, mw->mw_nents, mw->mw_dir);
> +		dma_unmap_sg(ia->ri_device->dma_device, mw->mw_sg, mw->mw_nents,
> +			     mw->mw_dir);
> 		rpcrdma_put_mw(r_xprt, mw);
> 	}
> 	return;
> diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
> index c52e0f2ffe52..6b6e700a5a68 100644
> --- a/net/sunrpc/xprtrdma/rpc_rdma.c
> +++ b/net/sunrpc/xprtrdma/rpc_rdma.c
> @@ -476,8 +476,8 @@ rpcrdma_prepare_hdr_sge(struct rpcrdma_ia *ia, struct rpcrdma_req *req,
> 	}
> 	sge->length = len;
> 
> -	ib_dma_sync_single_for_device(ia->ri_device, sge->addr,
> -				      sge->length, DMA_TO_DEVICE);
> +	dma_sync_single_for_device(ia->ri_device->dma_device, sge->addr,
> +				   sge->length, DMA_TO_DEVICE);
> 	req->rl_send_wr.num_sge++;
> 	return true;
> }
> @@ -505,8 +505,8 @@ rpcrdma_prepare_msg_sges(struct rpcrdma_ia *ia, struct rpcrdma_req *req,
> 	sge[sge_no].addr = rdmab_addr(rb);
> 	sge[sge_no].length = xdr->head[0].iov_len;
> 	sge[sge_no].lkey = rdmab_lkey(rb);
> -	ib_dma_sync_single_for_device(device, sge[sge_no].addr,
> -				      sge[sge_no].length, DMA_TO_DEVICE);
> +	dma_sync_single_for_device(device->dma_device, sge[sge_no].addr,
> +				   sge[sge_no].length, DMA_TO_DEVICE);
> 
> 	/* If there is a Read chunk, the page list is being handled
> 	 * via explicit RDMA, and thus is skipped here. However, the
> @@ -547,10 +547,11 @@ rpcrdma_prepare_msg_sges(struct rpcrdma_ia *ia, struct rpcrdma_req *req,
> 				goto out_mapping_overflow;
> 
> 			len = min_t(u32, PAGE_SIZE - page_base, remaining);
> -			sge[sge_no].addr = ib_dma_map_page(device, *ppages,
> -							   page_base, len,
> -							   DMA_TO_DEVICE);
> -			if (ib_dma_mapping_error(device, sge[sge_no].addr))
> +			sge[sge_no].addr = dma_map_page(device->dma_device,
> +							*ppages, page_base, len,
> +							DMA_TO_DEVICE);
> +			if (dma_mapping_error(device->dma_device,
> +					      sge[sge_no].addr))
> 				goto out_mapping_err;
> 			sge[sge_no].length = len;
> 			sge[sge_no].lkey = lkey;
> @@ -574,10 +575,9 @@ rpcrdma_prepare_msg_sges(struct rpcrdma_ia *ia, struct rpcrdma_req *req,
> 
> map_tail:
> 		sge_no++;
> -		sge[sge_no].addr = ib_dma_map_page(device, page,
> -						   page_base, len,
> -						   DMA_TO_DEVICE);
> -		if (ib_dma_mapping_error(device, sge[sge_no].addr))
> +		sge[sge_no].addr = dma_map_page(device->dma_device, page,
> +						page_base, len, DMA_TO_DEVICE);
> +		if (dma_mapping_error(device->dma_device, sge[sge_no].addr))
> 			goto out_mapping_err;
> 		sge[sge_no].length = len;
> 		sge[sge_no].lkey = lkey;
> @@ -628,8 +628,8 @@ rpcrdma_unmap_sges(struct rpcrdma_ia *ia, struct rpcrdma_req *req)
> 
> 	sge = &req->rl_send_sge[2];
> 	for (count = req->rl_mapped_sges; count--; sge++)
> -		ib_dma_unmap_page(device, sge->addr, sge->length,
> -				  DMA_TO_DEVICE);
> +		dma_unmap_page(device->dma_device, sge->addr, sge->length,
> +			       DMA_TO_DEVICE);
> 	req->rl_mapped_sges = 0;
> }
> 
> diff --git a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
> index 288e35c2d8f4..d65abb351f5b 100644
> --- a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
> @@ -123,9 +123,10 @@ static int svc_rdma_bc_sendto(struct svcxprt_rdma *rdma,
> 	ctxt->sge[0].lkey = rdma->sc_pd->local_dma_lkey;
> 	ctxt->sge[0].length = sndbuf->len;
> 	ctxt->sge[0].addr =
> -	    ib_dma_map_page(rdma->sc_cm_id->device, ctxt->pages[0], 0,
> -			    sndbuf->len, DMA_TO_DEVICE);
> -	if (ib_dma_mapping_error(rdma->sc_cm_id->device, ctxt->sge[0].addr)) {
> +	    dma_map_page(rdma->sc_cm_id->device->dma_device, ctxt->pages[0], 0,
> +			 sndbuf->len, DMA_TO_DEVICE);
> +	if (dma_mapping_error(rdma->sc_cm_id->device->dma_device,
> +			      ctxt->sge[0].addr)) {
> 		ret = -EIO;
> 		goto out_unmap;
> 	}
> diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> index 57d35fbb1c28..6ca1786c3493 100644
> --- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> @@ -151,12 +151,11 @@ int rdma_read_chunk_lcl(struct svcxprt_rdma *xprt,
> 		rqstp->rq_respages = &rqstp->rq_arg.pages[pg_no+1];
> 		rqstp->rq_next_page = rqstp->rq_respages + 1;
> 		ctxt->sge[pno].addr =
> -			ib_dma_map_page(xprt->sc_cm_id->device,
> -					head->arg.pages[pg_no], pg_off,
> -					PAGE_SIZE - pg_off,
> -					DMA_FROM_DEVICE);
> -		ret = ib_dma_mapping_error(xprt->sc_cm_id->device,
> -					   ctxt->sge[pno].addr);
> +			dma_map_page(xprt->sc_cm_id->device->dma_device,
> +				     head->arg.pages[pg_no], pg_off,
> +				     PAGE_SIZE - pg_off, DMA_FROM_DEVICE);
> +		ret = dma_mapping_error(xprt->sc_cm_id->device->dma_device,
> +					ctxt->sge[pno].addr);
> 		if (ret)
> 			goto err;
> 		svc_rdma_count_mappings(xprt, ctxt);
> @@ -271,9 +270,8 @@ int rdma_read_chunk_frmr(struct svcxprt_rdma *xprt,
> 	else
> 		clear_bit(RDMACTXT_F_LAST_CTXT, &ctxt->flags);
> 
> -	dma_nents = ib_dma_map_sg(xprt->sc_cm_id->device,
> -				  frmr->sg, frmr->sg_nents,
> -				  frmr->direction);
> +	dma_nents = dma_map_sg(xprt->sc_cm_id->device->dma_device,
> +			       frmr->sg, frmr->sg_nents, frmr->direction);
> 	if (!dma_nents) {
> 		pr_err("svcrdma: failed to dma map sg %p\n",
> 		       frmr->sg);
> @@ -347,8 +345,8 @@ int rdma_read_chunk_frmr(struct svcxprt_rdma *xprt,
> 	atomic_inc(&rdma_stat_read);
> 	return ret;
>  err:
> -	ib_dma_unmap_sg(xprt->sc_cm_id->device,
> -			frmr->sg, frmr->sg_nents, frmr->direction);
> +	dma_unmap_sg(xprt->sc_cm_id->device->dma_device, frmr->sg,
> +		     frmr->sg_nents, frmr->direction);
> 	svc_rdma_put_context(ctxt, 0);
> 	svc_rdma_put_frmr(xprt, frmr);
> 	return ret;
> diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
> index ad4d286a83c5..5fa33ad92484 100644
> --- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
> @@ -148,8 +148,8 @@ static dma_addr_t dma_map_xdr(struct svcxprt_rdma *xprt,
> 			page = virt_to_page(xdr->tail[0].iov_base);
> 		}
> 	}
> -	dma_addr = ib_dma_map_page(xprt->sc_cm_id->device, page, xdr_off,
> -				   min_t(size_t, PAGE_SIZE, len), dir);
> +	dma_addr = dma_map_page(xprt->sc_cm_id->device->dma_device, page,
> +				xdr_off, min_t(size_t, PAGE_SIZE, len), dir);
> 	return dma_addr;
> }
> 
> @@ -269,8 +269,8 @@ static int send_write(struct svcxprt_rdma *xprt, struct svc_rqst *rqstp,
> 			dma_map_xdr(xprt, &rqstp->rq_res, xdr_off,
> 				    sge_bytes, DMA_TO_DEVICE);
> 		xdr_off += sge_bytes;
> -		if (ib_dma_mapping_error(xprt->sc_cm_id->device,
> -					 sge[sge_no].addr))
> +		if (dma_mapping_error(xprt->sc_cm_id->device->dma_device,
> +				      sge[sge_no].addr))
> 			goto err;
> 		svc_rdma_count_mappings(xprt, ctxt);
> 		sge[sge_no].lkey = xprt->sc_pd->local_dma_lkey;
> @@ -478,9 +478,10 @@ static int send_reply(struct svcxprt_rdma *rdma,
> 	ctxt->sge[0].lkey = rdma->sc_pd->local_dma_lkey;
> 	ctxt->sge[0].length = svc_rdma_xdr_get_reply_hdr_len(rdma_resp);
> 	ctxt->sge[0].addr =
> -	    ib_dma_map_page(rdma->sc_cm_id->device, page, 0,
> -			    ctxt->sge[0].length, DMA_TO_DEVICE);
> -	if (ib_dma_mapping_error(rdma->sc_cm_id->device, ctxt->sge[0].addr))
> +	    dma_map_page(rdma->sc_cm_id->device->dma_device, page, 0,
> +			 ctxt->sge[0].length, DMA_TO_DEVICE);
> +	if (dma_mapping_error(rdma->sc_cm_id->device->dma_device,
> +			      ctxt->sge[0].addr))
> 		goto err;
> 	svc_rdma_count_mappings(rdma, ctxt);
> 
> @@ -495,8 +496,8 @@ static int send_reply(struct svcxprt_rdma *rdma,
> 			dma_map_xdr(rdma, &rqstp->rq_res, xdr_off,
> 				    sge_bytes, DMA_TO_DEVICE);
> 		xdr_off += sge_bytes;
> -		if (ib_dma_mapping_error(rdma->sc_cm_id->device,
> -					 ctxt->sge[sge_no].addr))
> +		if (dma_mapping_error(rdma->sc_cm_id->device->dma_device,
> +				      ctxt->sge[sge_no].addr))
> 			goto err;
> 		svc_rdma_count_mappings(rdma, ctxt);
> 		ctxt->sge[sge_no].lkey = rdma->sc_pd->local_dma_lkey;
> @@ -677,9 +678,10 @@ void svc_rdma_send_error(struct svcxprt_rdma *xprt, struct rpcrdma_msg *rmsgp,
> 	/* Prepare SGE for local address */
> 	ctxt->sge[0].lkey = xprt->sc_pd->local_dma_lkey;
> 	ctxt->sge[0].length = length;
> -	ctxt->sge[0].addr = ib_dma_map_page(xprt->sc_cm_id->device,
> -					    p, 0, length, DMA_TO_DEVICE);
> -	if (ib_dma_mapping_error(xprt->sc_cm_id->device, ctxt->sge[0].addr)) {
> +	ctxt->sge[0].addr = dma_map_page(xprt->sc_cm_id->device->dma_device,
> +					 p, 0, length, DMA_TO_DEVICE);
> +	if (dma_mapping_error(xprt->sc_cm_id->device->dma_device,
> +			      ctxt->sge[0].addr)) {
> 		dprintk("svcrdma: Error mapping buffer for protocol error\n");
> 		svc_rdma_put_context(ctxt, 1);
> 		return;
> diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
> index ca2799af05a6..ed19de5c9a34 100644
> --- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
> @@ -237,10 +237,8 @@ void svc_rdma_unmap_dma(struct svc_rdma_op_ctxt *ctxt)
> 		 * last WR that uses it completes.
> 		 */
> 		if (ctxt->sge[i].lkey == lkey)
> -			ib_dma_unmap_page(device,
> -					    ctxt->sge[i].addr,
> -					    ctxt->sge[i].length,
> -					    ctxt->direction);
> +			dma_unmap_page(device->dma_device, ctxt->sge[i].addr,
> +				       ctxt->sge[i].length, ctxt->direction);
> 	}
> 	ctxt->mapped_sges = 0;
> }
> @@ -600,10 +598,9 @@ int svc_rdma_post_recv(struct svcxprt_rdma *xprt, gfp_t flags)
> 		if (!page)
> 			goto err_put_ctxt;
> 		ctxt->pages[sge_no] = page;
> -		pa = ib_dma_map_page(xprt->sc_cm_id->device,
> -				     page, 0, PAGE_SIZE,
> -				     DMA_FROM_DEVICE);
> -		if (ib_dma_mapping_error(xprt->sc_cm_id->device, pa))
> +		pa = dma_map_page(xprt->sc_cm_id->device->dma_device,
> +				  page, 0, PAGE_SIZE, DMA_FROM_DEVICE);
> +		if (dma_mapping_error(xprt->sc_cm_id->device->dma_device, pa))
> 			goto err_put_ctxt;
> 		svc_rdma_count_mappings(xprt, ctxt);
> 		ctxt->sge[sge_no].addr = pa;
> @@ -941,8 +938,8 @@ void svc_rdma_put_frmr(struct svcxprt_rdma *rdma,
> 		       struct svc_rdma_fastreg_mr *frmr)
> {
> 	if (frmr) {
> -		ib_dma_unmap_sg(rdma->sc_cm_id->device,
> -				frmr->sg, frmr->sg_nents, frmr->direction);
> +		dma_unmap_sg(rdma->sc_cm_id->device->dma_device, frmr->sg,
> +			     frmr->sg_nents, frmr->direction);
> 		spin_lock_bh(&rdma->sc_frmr_q_lock);
> 		WARN_ON_ONCE(!list_empty(&frmr->frmr_list));
> 		list_add(&frmr->frmr_list, &rdma->sc_frmr_q);
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
> index 11d07748f699..ba15926173e5 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -179,9 +179,9 @@ rpcrdma_wc_receive(struct ib_cq *cq, struct ib_wc *wc)
> 	rep->rr_wc_flags = wc->wc_flags;
> 	rep->rr_inv_rkey = wc->ex.invalidate_rkey;
> 
> -	ib_dma_sync_single_for_cpu(rep->rr_device,
> -				   rdmab_addr(rep->rr_rdmabuf),
> -				   rep->rr_len, DMA_FROM_DEVICE);
> +	dma_sync_single_for_cpu(rep->rr_device->dma_device,
> +				rdmab_addr(rep->rr_rdmabuf),
> +				rep->rr_len, DMA_FROM_DEVICE);
> 
> 	rpcrdma_update_granted_credits(rep);
> 
> @@ -1259,11 +1259,9 @@ __rpcrdma_dma_map_regbuf(struct rpcrdma_ia *ia, struct rpcrdma_regbuf *rb)
> 	if (rb->rg_direction == DMA_NONE)
> 		return false;
> 
> -	rb->rg_iov.addr = ib_dma_map_single(ia->ri_device,
> -					    (void *)rb->rg_base,
> -					    rdmab_length(rb),
> -					    rb->rg_direction);
> -	if (ib_dma_mapping_error(ia->ri_device, rdmab_addr(rb)))
> +	rb->rg_iov.addr = dma_map_single(ia->ri_device->dma_device, rb->rg_base,
> +					 rdmab_length(rb), rb->rg_direction);
> +	if (dma_mapping_error(ia->ri_device->dma_device, rdmab_addr(rb)))
> 		return false;
> 
> 	rb->rg_device = ia->ri_device;
> @@ -1277,8 +1275,8 @@ rpcrdma_dma_unmap_regbuf(struct rpcrdma_regbuf *rb)
> 	if (!rpcrdma_regbuf_is_mapped(rb))
> 		return;
> 
> -	ib_dma_unmap_single(rb->rg_device, rdmab_addr(rb),
> -			    rdmab_length(rb), rb->rg_direction);
> +	dma_unmap_single(rb->rg_device->dma_device, rdmab_addr(rb),
> +			 rdmab_length(rb), rb->rg_direction);
> 	rb->rg_device = NULL;
> }
> 
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Chuck Lever
