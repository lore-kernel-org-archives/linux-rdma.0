From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 08/12] IB/core: generic RDMA READ/WRITE API
Date: Wed, 13 Apr 2016 15:50:42 +0200
Message-ID: <20160413135042.GA14648@lst.de>
References: <1460410360-13104-1-git-send-email-hch@lst.de> <1460410360-13104-9-git-send-email-hch@lst.de> <570D8A42.9040107@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <570D8A42.9040107-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 12, 2016 at 04:52:34PM -0700, Bart Van Assche wrote:
> Please clarify the comment above this function. The way that comment is 
> written seems to contradict the code for iWARP writes.

Thanks, fixed.

>> +		count++;
>> +	} else {
>> +		reg->inv_wr.next = NULL;
>> +	}
>> +
>> +	ret = ib_map_mr_sg(reg->mr, sg, nents, offset, PAGE_SIZE);
>> +	if (ret < nents) {
>> +		ib_mr_pool_put(qp, &qp->rdma_mrs, reg->mr);
>> +		return -EINVAL;
>> +	}
>
> The above code assumes that the length of each sg list element is lower 
> than or equal to mr->page_size. I think this is something that should be 
> documented since the block layer has to be configured explicitly to ensure 
> this.

It shouldn't assume that - ib_map_mr_sg just uses PAGE_SIZE as
the MR granularuty.  Note that the block layer isn't involved for any of
the users of this function - it's used on the target sides of iSER, SRP,
and (out of tree for a few more weeks) NVMe over fabrics.  All of them
only provide 4k segments so while I think this code should handle larger
segments, there is no way to verify that until we have consumers that
provide larger segments.  I think SCST had some allocator that could
use larger pages, and Pure Storage mention they had LIO changes to
use large pages as well, so if this comes up I think we should be
able to support it without too much effort.
>
>> +	u32 pages_per_mr = rdma_rw_fr_page_list_len(qp->pd->device);
>> +	int i, j, ret = 0, count = 0;
>> +
>> +	ctx->nr_ops = (sg_cnt + pages_per_mr - 1) / pages_per_mr;
>> +	ctx->reg = kcalloc(ctx->nr_ops, sizeof(*ctx->reg), GFP_KERNEL);
>> +	if (!ctx->reg) {
>> +		ret = -ENOMEM;
>> +		goto out;
>> +	}
>> +
>> +	for (i = 0; i < ctx->nr_ops; i++) {
>> +		struct rdma_rw_reg_ctx *prev = i ? &ctx->reg[i - 1] : NULL;
>> +		struct rdma_rw_reg_ctx *reg = &ctx->reg[i];
>> +		u32 nents = min(sg_cnt, pages_per_mr);
>
> The same min(sg_cnt, pages_per_mr) computation occurs here and in 
> rdma_rw_init_one_mr(). Is there a way to avoid that duplication?

It's just a single min statement, so coming up with an inline function
to wrap seems a little too much overhead to me.  If you have a better
suggestion I'd be happy to look into it.

>> +#define RDMA_RW_SINGLE_WR	0
>> +#define RDMA_RW_MULTI_WR	1
>> +#define RDMA_RW_MR		2
>
> The above constants are only used in the rw.c source file. Do we need these 
> constants in the header file or can these be moved into source file rw.c?

I have moved them, and converted the constants to an enum while I was at
it.

Thanks for the review!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
