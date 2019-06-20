From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [RFC PATCH 20/28] IB/core: Introduce API for initializing a RW
 ctx from a DMA address
Date: Thu, 20 Jun 2019 10:59:44 -0600
Message-ID: <f9186b2b-7737-965f-2dca-25e40e566e64@deltatee.com>
References: <20190620161240.22738-1-logang@deltatee.com>
 <20190620161240.22738-21-logang@deltatee.com>
 <20190620164909.GC19891@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190620164909.GC19891@ziepe.ca>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Stephen Bates <sbates@raithlin.com>
List-Id: linux-rdma@vger.kernel.org



On 2019-06-20 10:49 a.m., Jason Gunthorpe wrote:
> On Thu, Jun 20, 2019 at 10:12:32AM -0600, Logan Gunthorpe wrote:
>> Introduce rdma_rw_ctx_dma_init() and rdma_rw_ctx_dma_destroy() which
>> peform the same operation as rdma_rw_ctx_init() and
>> rdma_rw_ctx_destroy() respectively except they operate on a DMA
>> address and length instead of an SGL.
>>
>> This will be used for struct page-less P2PDMA, but there's also
>> been opinions expressed to migrate away from SGLs and struct
>> pages in the RDMA APIs and this will likely fit with that
>> effort.
>>
>> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
>>  drivers/infiniband/core/rw.c | 74 ++++++++++++++++++++++++++++++------
>>  include/rdma/rw.h            |  6 +++
>>  2 files changed, 69 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
>> index 32ca8429eaae..cefa6b930bc8 100644
>> +++ b/drivers/infiniband/core/rw.c
>> @@ -319,6 +319,39 @@ int rdma_rw_ctx_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
>>  }
>>  EXPORT_SYMBOL(rdma_rw_ctx_init);
>>  
>> +/**
>> + * rdma_rw_ctx_dma_init - initialize a RDMA READ/WRITE context from a
>> + *	DMA address instead of SGL
>> + * @ctx:	context to initialize
>> + * @qp:		queue pair to operate on
>> + * @port_num:	port num to which the connection is bound
>> + * @addr:	DMA address to READ/WRITE from/to
>> + * @len:	length of memory to operate on
>> + * @remote_addr:remote address to read/write (relative to @rkey)
>> + * @rkey:	remote key to operate on
>> + * @dir:	%DMA_TO_DEVICE for RDMA WRITE, %DMA_FROM_DEVICE for RDMA READ
>> + *
>> + * Returns the number of WQEs that will be needed on the workqueue if
>> + * successful, or a negative error code.
>> + */
>> +int rdma_rw_ctx_dma_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
>> +		u8 port_num, dma_addr_t addr, u32 len, u64 remote_addr,
>> +		u32 rkey, enum dma_data_direction dir)
> 
> Why not keep the same basic signature here but replace the scatterlist
> with the dma vec ?

Could do. At the moment, I had no need for dma_vec in this interface.

>> +{
>> +	struct scatterlist sg;
>> +
>> +	sg_dma_address(&sg) = addr;
>> +	sg_dma_len(&sg) = len;
> 
> This needs to fail if the driver is one of the few that require
> struct page to work..

Yes, right. Currently P2PDMA checks for the use of dma_virt_ops. And
that probably should also be done here. But is that sufficient? You're
probably right that it'll take an audit of the RDMA tree to sort that out.

> Really want I want to do is to have this new 'dma vec' pushed through
> the RDMA APIs so we know that if a driver is using the dma vec
> interface it is struct page free.

Yeah, I know you were talking about heading this way during LSF/MM and
is partly what inspired this series. However, largely, my focus for this
RFC was the block layer to see this is an acceptable approach -- I just
kind of hacked RDMA for now.

> This is not so hard to do, as most drivers are already struct page
> free, but is pretty much blocked on needing some way to go from the
> block layer SGL world to the dma vec world that does not hurt storage
> performance.

Maybe I can end up helping with that if it helps push the ideas here
through. (And assuming people think it's an acceptable approach for the
block-layer side of things).

Thanks,

Logan
