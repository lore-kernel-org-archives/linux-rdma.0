From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 08/12] IB/core: generic RDMA READ/WRITE API
Date: Tue, 12 Apr 2016 16:52:34 -0700
Message-ID: <570D8A42.9040107@sandisk.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
 <1460410360-13104-9-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460410360-13104-9-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 04/11/2016 02:32 PM, Christoph Hellwig wrote:
> +/*
> + * Check if the device will use memory registration for this RW operation.
> + * We currently always use memory registrations for iWarp reads, and iWarp
> + * writes, but never for IB and RoCE.
> + *
> + * XXX: In the future we can hopefully fine tune this based on HCA driver
> + * input.
> + */
> +static inline bool rdma_rw_io_needs_mr(struct ib_device *dev, u8 port_num,
> +		enum dma_data_direction dir, int dma_nents)
> +{
> +	if (rdma_protocol_iwarp(dev, port_num) && dir == DMA_FROM_DEVICE)
> +		return true;
> +	if (unlikely(rdma_rw_force_mr))
> +		return true;
> +	return false;
> +}

Please clarify the comment above this function. The way that comment is 
written seems to contradict the code for iWARP writes.

> +static int rdma_rw_init_one_mr(struct ib_qp *qp, u8 port_num,
> +		struct rdma_rw_reg_ctx *reg, struct scatterlist *sg,
> +		u32 sg_cnt, u32 offset)
> +{
> +	u32 pages_per_mr = rdma_rw_fr_page_list_len(qp->pd->device);
> +	u32 nents = min(sg_cnt, pages_per_mr);
> +	int count = 0, ret;
> +
> +	reg->mr = ib_mr_pool_get(qp, &qp->rdma_mrs);
> +	if (!reg->mr)
> +		return -EAGAIN;
> +
> +	if (reg->mr->need_inval) {
> +		reg->inv_wr.opcode = IB_WR_LOCAL_INV;
> +		reg->inv_wr.ex.invalidate_rkey = reg->mr->lkey;
> +		reg->inv_wr.next = &reg->reg_wr.wr;
> +		count++;
> +	} else {
> +		reg->inv_wr.next = NULL;
> +	}
> +
> +	ret = ib_map_mr_sg(reg->mr, sg, nents, offset, PAGE_SIZE);
> +	if (ret < nents) {
> +		ib_mr_pool_put(qp, &qp->rdma_mrs, reg->mr);
> +		return -EINVAL;
> +	}

The above code assumes that the length of each sg list element is lower 
than or equal to mr->page_size. I think this is something that should be 
documented since the block layer has to be configured explicitly to 
ensure this.

> +static int rdma_rw_init_mr_wrs(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
> +		u8 port_num, struct scatterlist *sg, u32 sg_cnt, u32 offset,
> +		u64 remote_addr, u32 rkey, enum dma_data_direction dir)
> +{
> +	u32 pages_per_mr = rdma_rw_fr_page_list_len(qp->pd->device);
> +	int i, j, ret = 0, count = 0;
> +
> +	ctx->nr_ops = (sg_cnt + pages_per_mr - 1) / pages_per_mr;
> +	ctx->reg = kcalloc(ctx->nr_ops, sizeof(*ctx->reg), GFP_KERNEL);
> +	if (!ctx->reg) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	for (i = 0; i < ctx->nr_ops; i++) {
> +		struct rdma_rw_reg_ctx *prev = i ? &ctx->reg[i - 1] : NULL;
> +		struct rdma_rw_reg_ctx *reg = &ctx->reg[i];
> +		u32 nents = min(sg_cnt, pages_per_mr);

The same min(sg_cnt, pages_per_mr) computation occurs here and in 
rdma_rw_init_one_mr(). Is there a way to avoid that duplication?

> +#define RDMA_RW_SINGLE_WR	0
> +#define RDMA_RW_MULTI_WR	1
> +#define RDMA_RW_MR		2

The above constants are only used in the rw.c source file. Do we need 
these constants in the header file or can these be moved into source 
file rw.c?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
