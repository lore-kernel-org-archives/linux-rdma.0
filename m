From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 7/9] IB/core: generic RDMA READ/WRITE API
Date: Wed, 9 Mar 2016 14:07:23 +0100
Message-ID: <20160309130723.GD31210@lst.de>
References: <1457461000-24088-1-git-send-email-hch@lst.de> <1457461000-24088-8-git-send-email-hch@lst.de> <56DF44FC.8070103@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56DF44FC.8070103@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>, "dledford@redhat.com" <dledford@redhat.com>, "sagig@mellanox.com" <sagig@mellanox.com>, "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 08, 2016 at 01:32:44PM -0800, Bart Van Assche wrote:
> The above pr_info() message does not provide enough context information to 
> allow a user to figure out why that message was reported. Please leave that 
> message out and make the callers of this function report MR allocation 
> failure wherever useful.

Ok, I'll remove it.

>> +		ret = ib_map_mr_sg(reg->mr, sg, nents, offset,
>> +				PAGE_SIZE);
> [ ... ]
>> +		sg = sg_next(sg);
>
> ib_map_mr_sg() processed 'ret' elements of scatterlist 'sg'. So why is 'sg' 
> only advanced by one element at the end of the loop?

I think the multiple MR case here is simply broken, as we never hit
for the iSER or NVMe over Fabrics I/O sizes.  I think the safest
is to simply not allow for it.  I'll update the patch to disable the
loop, and add a helper for the driver to query the max I/O size
supported by the device.

>> +		for (j = 0; j < nr_sge; j++, sg = sg_next(sg)) {
>> +			rdma_wr->wr.num_sge++;
>> +
>> +			sge->addr = ib_sg_dma_address(dev, sg) + offset;
>> +			sge->length = ib_sg_dma_len(dev, sg) - offset;
>> +			sge->lkey = qp->pd->local_dma_lkey;
>> +
>> +			total_len += sge->length;
>> +			sge++;
>> +			sge_left--;
>> +			offset = 0;
>> +		}
>
> Shouldn't there be a break statement in the above loop that stops this loop 
> if the end of the sg list has been reached? Less than nr_sge iterations 
> will be needed to reach the end of the sg list if the length of the sg list 
> is not a multiple of nr_sge.

nr_sge is calculated as:

	u32 nr_sge = min(sge_left, max_sge);

so it will never contain more iteration than we can possibly do.
