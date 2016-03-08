From: Leon Romanovsky <leon@leon.nu>
Subject: Re: [PATCH v4 9/9] IB/srpt: convert to the generic RDMA READ/WRITE
 API
Date: Tue, 8 Mar 2016 22:13:42 +0200
Message-ID: <20160308201342.GL13396@leon.nu>
References: <1457461000-24088-1-git-send-email-hch@lst.de>
 <1457461000-24088-10-git-send-email-hch@lst.de>
Reply-To: leon@leon.nu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1457461000-24088-10-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: dledford@redhat.com, bart.vanassche@sandisk.com, sagig@mellanox.com, swise@opengridcomputing.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 08, 2016 at 07:16:40PM +0100, Christoph Hellwig wrote:
> Replace the homegrown RDMA READ/WRITE code in srpt with the generic API.
> The only real twist here is that we need to allocate one Linux scatterlist
> per direct buffer in the SRP command, and chain them before handing them
> off to the target core.
> 
> As a side-effect of the conversion the driver will also chain the SEND
> of the SRP response to the RDMA WRITE WRs for a DATA OUT command, and
> properly account for RDMA WRITE WRs instead of just for RDMA READ WRs
> like the driver previously did.
> 
> We now allocate half of the SQ size to RDMA READ/WRITE contexts, assuming
> by default one RDMA READ or WRITE operation per command.  If a command
> has multiple operations it will eat into the budget but will still succeed,
> possible after waiting for WQEs to be available.
> 
> Also ensure the QPs request the maximum allowed SGEs so that RDMA R/W API
> works correctly.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 693 +++++++++++-----------------------
>  drivers/infiniband/ulp/srpt/ib_srpt.h |  30 +-
>  2 files changed, 242 insertions(+), 481 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 25bdaee..05bdec8 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -765,52 +765,6 @@ static int srpt_post_recv(struct srpt_device *sdev,
>  }
>  
>  /**
> - * srpt_post_send() - Post an IB send request.
> - *
> - * Returns zero upon success and a non-zero value upon failure.
> - */
> -static int srpt_post_send(struct srpt_rdma_ch *ch,
> -			  struct srpt_send_ioctx *ioctx, int len)
> -{
> -	struct ib_sge list;
> -	struct ib_send_wr wr, *bad_wr;
> -	struct srpt_device *sdev = ch->sport->sdev;
> -	int ret;
> -
> -	atomic_inc(&ch->req_lim);
> -
> -	ret = -ENOMEM;
> -	if (unlikely(atomic_dec_return(&ch->sq_wr_avail) < 0)) {
> -		pr_warn("IB send queue full (needed 1)\n");
> -		goto out;
> -	}
> -
> -	ib_dma_sync_single_for_device(sdev->device, ioctx->ioctx.dma, len,
> -				      DMA_TO_DEVICE);
> -
> -	list.addr = ioctx->ioctx.dma;
> -	list.length = len;
> -	list.lkey = sdev->pd->local_dma_lkey;
> -
> -	ioctx->ioctx.cqe.done = srpt_send_done;
> -	wr.next = NULL;
> -	wr.wr_cqe = &ioctx->ioctx.cqe;
> -	wr.sg_list = &list;
> -	wr.num_sge = 1;
> -	wr.opcode = IB_WR_SEND;
> -	wr.send_flags = IB_SEND_SIGNALED;
> -
> -	ret = ib_post_send(ch->qp, &wr, &bad_wr);
> -
> -out:
> -	if (ret < 0) {
> -		atomic_inc(&ch->sq_wr_avail);
> -		atomic_dec(&ch->req_lim);
> -	}
> -	return ret;
> -}
> -
> -/**
>   * srpt_zerolength_write() - Perform a zero-length RDMA write.
>   *
>   * A quote from the InfiniBand specification: C9-88: For an HCA responder
> @@ -843,6 +797,110 @@ static void srpt_zerolength_write_done(struct ib_cq *cq, struct ib_wc *wc)
>  	}
>  }
>  
> +static int srpt_alloc_rw_ctxs(struct srpt_send_ioctx *ioctx,
> +		struct srp_direct_buf *db, int nbufs, struct scatterlist **sg,
> +		unsigned *sg_cnt)
> +{
> +	enum dma_data_direction dir = target_reverse_dma_direction(&ioctx->cmd);
> +	struct srpt_rdma_ch *ch = ioctx->ch;
> +	struct scatterlist *prev = NULL;
> +	unsigned prev_nents;
> +	int ret, i;
> +
> +	if (nbufs == 1) {
> +		ioctx->rw_ctxs = &ioctx->s_rw_ctx;
> +	} else {
> +		ioctx->rw_ctxs = kmalloc_array(nbufs, sizeof(*ioctx->rw_ctxs),
> +				GFP_KERNEL);
> +		if (!ioctx->rw_ctxs)
> +			return -ENOMEM;
> +	}
> +
> +	for (i = 0; i < nbufs; i++, db++) {
> +		struct srpt_rw_ctx *ctx = &ioctx->rw_ctxs[i];
> +		u64 remote_addr = be64_to_cpu(db->va);
> +		u32 size = be32_to_cpu(db->len);
> +		u32 rkey = be32_to_cpu(db->key);
> +
> +		ret = target_alloc_sgl(&ctx->sg, &ctx->nents, size, false,
> +				i < nbufs - 1);
> +		if (ret)
> +			goto unwind;
> +
> +		ret = rdma_rw_ctx_init(&ctx->rw, ch->qp, ch->sport->port,
> +				ctx->sg, ctx->nents, 0, remote_addr, rkey, dir);
> +		if (ret < 0) {
> +			target_free_sgl(ctx->sg, ctx->nents);
> +			goto unwind;
> +		}
> +
> +		ioctx->n_rdma += ret;
> +
> +		if (prev) {
> +			sg_unmark_end(&prev[prev_nents - 1]);
> +			sg_chain(prev, prev_nents + 1, ctx->sg);
> +		} else {
> +			*sg = ctx->sg;
> +		}
> +
> +		prev = ctx->sg;
> +		prev_nents = ctx->nents;
> +
> +		*sg_cnt += ctx->nents;
> +	}
> +
> +	ioctx->n_rw_ctx = nbufs;
> +	return 0;
> +
> +unwind:
> +	while (--i >= 0) {
> +		struct srpt_rw_ctx *ctx = &ioctx->rw_ctxs[i];
> +
> +		rdma_rw_ctx_destroy(&ctx->rw, ch->qp, ch->sport->port,
> +				ctx->sg, ctx->nents, dir);
> +		target_free_sgl(ctx->sg, ctx->nents);
> +	}
> +	if (ioctx->rw_ctxs && ioctx->rw_ctxs != &ioctx->s_rw_ctx)

You can jump to unwind label from one place only. In that stage
"ioctx->rw_ctxs != NULL" will always be true.

> +		kfree(ioctx->rw_ctxs);
> +	return ret;
> +}
