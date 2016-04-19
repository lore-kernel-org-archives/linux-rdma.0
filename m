From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH 11/12] IB/core: add RW API support for signature MRs
Date: Tue, 19 Apr 2016 17:20:09 +0300
Message-ID: <57163E99.8090301@grimberg.me>
References: <1461010463-6603-1-git-send-email-hch@lst.de>
 <1461010463-6603-12-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461010463-6603-12-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> +/**
> + * rdma_rw_ctx_signature init - initialize a RW context with signature offload
> + * @ctx:	context to initialize
> + * @qp:		queue pair to operate on
> + * @port_num:	port num to which the connection is bound
> + * @sg:		scatterlist to READ/WRITE from/to
> + * @sg_cnt:	number of entries in @sg
> + * @prot_sg:	scatterlist to READ/WRITE protection information from/to
> + * @prot_sg_cnt: number of entries in @prot_sg
> + * @sig_attrs:	signature offloading algorithms
> + * @remote_addr:remote address to read/write (relative to @rkey)
> + * @rkey:	remote key to operate on
> + * @dir:	%DMA_TO_DEVICE for RDMA WRITE, %DMA_FROM_DEVICE for RDMA READ
> + *
> + * Returns the number of WQEs that will be needed on the workqueue if
> + * successful, or a negative error code.
> + */
> +int rdma_rw_ctx_signature_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
> +		u8 port_num, struct scatterlist *sg, u32 sg_cnt,
> +		struct scatterlist *prot_sg, u32 prot_sg_cnt,
> +		struct ib_sig_attrs *sig_attrs,
> +		u64 remote_addr, u32 rkey, enum dma_data_direction dir)
> +{
> +	struct ib_device *dev = qp->pd->device;
> +	u32 pages_per_mr = rdma_rw_fr_page_list_len(qp->pd->device);
> +	struct ib_rdma_wr *rdma_wr;
> +	struct ib_send_wr *prev_wr = NULL;
> +	int count = 0, ret;
> +
> +	if (sg_cnt > pages_per_mr || prot_sg_cnt > pages_per_mr) {
> +		pr_err("SG count too large\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = ib_dma_map_sg(dev, sg, sg_cnt, dir);
> +	if (!ret)
> +		return -ENOMEM;
> +	sg_cnt = ret;
> +
> +	ret = ib_dma_map_sg(dev, prot_sg, prot_sg_cnt, dir);
> +	if (!ret) {
> +		ret = -ENOMEM;
> +		goto out_unmap_sg;
> +	}
> +	prot_sg_cnt = ret;
> +
> +	ctx->type = RDMA_RW_SIG_MR;
> +	ctx->nr_ops = 1;
> +	ctx->sig = kcalloc(1, sizeof(*ctx->sig), GFP_KERNEL);
> +	if (!ctx->sig) {
> +		ret = -ENOMEM;
> +		goto out_unmap_prot_sg;
> +	}
> +
> +	ret = rdma_rw_init_one_mr(qp, port_num, &ctx->sig->data, sg, sg_cnt, 0);
> +	if (ret < 0)
> +		goto out_free_ctx;
> +	count += ret;
> +	prev_wr = &ctx->sig->data.reg_wr.wr;
> +

In isert if the we have a single sg entry, we use the local_dma_lkey
just so we can skip a registration (also for protection sg), perhaps
rdma_rw_init_one_mr can do this optimization too?

I'm planning to rework some of the signature API, but it would be
nice not to lose this optimization in the mean time...

Other than that, looks really good,

Reviewed-by: Sagi Grimbeg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
