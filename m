From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v4 7/9] IB/core: generic RDMA READ/WRITE API
Date: Tue, 8 Mar 2016 13:32:44 -0800
Message-ID: <56DF44FC.8070103@sandisk.com>
References: <1457461000-24088-1-git-send-email-hch@lst.de>
 <1457461000-24088-8-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1457461000-24088-8-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "dledford@redhat.com" <dledford@redhat.com>
Cc: "sagig@mellanox.com" <sagig@mellanox.com>, "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 03/08/2016 10:16 AM, Christoph Hellwig wrote:
> +		reg->mr = ib_mr_pool_get(qp, &qp->rdma_mrs);
> +		if (!reg->mr) {
> +			pr_info("failed to allocate MR from pool\n");
> +			ret = -EAGAIN;
> +			goto out_free;
> +		}

The above pr_info() message does not provide enough context information 
to allow a user to figure out why that message was reported. Please 
leave that message out and make the callers of this function report MR 
allocation failure wherever useful.

> +		ret = ib_map_mr_sg(reg->mr, sg, nents, offset,
> +				PAGE_SIZE);
[ ... ]
> +		sg = sg_next(sg);

ib_map_mr_sg() processed 'ret' elements of scatterlist 'sg'. So why is 
'sg' only advanced by one element at the end of the loop?

> +		for (j = 0; j < nr_sge; j++, sg = sg_next(sg)) {
> +			rdma_wr->wr.num_sge++;
> +
> +			sge->addr = ib_sg_dma_address(dev, sg) + offset;
> +			sge->length = ib_sg_dma_len(dev, sg) - offset;
> +			sge->lkey = qp->pd->local_dma_lkey;
> +
> +			total_len += sge->length;
> +			sge++;
> +			sge_left--;
> +			offset = 0;
> +		}

Shouldn't there be a break statement in the above loop that stops this 
loop if the end of the sg list has been reached? Less than nr_sge 
iterations will be needed to reach the end of the sg list if the length 
of the sg list is not a multiple of nr_sge.

Bart.
