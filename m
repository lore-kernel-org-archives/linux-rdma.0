From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC PATCH 20/28] IB/core: Introduce API for initializing a RW
 ctx from a DMA address
Date: Thu, 20 Jun 2019 13:49:09 -0300
Message-ID: <20190620164909.GC19891@ziepe.ca>
References: <20190620161240.22738-1-logang@deltatee.com>
 <20190620161240.22738-21-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190620161240.22738-21-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Stephen Bates <sbates@raithlin.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 20, 2019 at 10:12:32AM -0600, Logan Gunthorpe wrote:
> Introduce rdma_rw_ctx_dma_init() and rdma_rw_ctx_dma_destroy() which
> peform the same operation as rdma_rw_ctx_init() and
> rdma_rw_ctx_destroy() respectively except they operate on a DMA
> address and length instead of an SGL.
> 
> This will be used for struct page-less P2PDMA, but there's also
> been opinions expressed to migrate away from SGLs and struct
> pages in the RDMA APIs and this will likely fit with that
> effort.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
>  drivers/infiniband/core/rw.c | 74 ++++++++++++++++++++++++++++++------
>  include/rdma/rw.h            |  6 +++
>  2 files changed, 69 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
> index 32ca8429eaae..cefa6b930bc8 100644
> +++ b/drivers/infiniband/core/rw.c
> @@ -319,6 +319,39 @@ int rdma_rw_ctx_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
>  }
>  EXPORT_SYMBOL(rdma_rw_ctx_init);
>  
> +/**
> + * rdma_rw_ctx_dma_init - initialize a RDMA READ/WRITE context from a
> + *	DMA address instead of SGL
> + * @ctx:	context to initialize
> + * @qp:		queue pair to operate on
> + * @port_num:	port num to which the connection is bound
> + * @addr:	DMA address to READ/WRITE from/to
> + * @len:	length of memory to operate on
> + * @remote_addr:remote address to read/write (relative to @rkey)
> + * @rkey:	remote key to operate on
> + * @dir:	%DMA_TO_DEVICE for RDMA WRITE, %DMA_FROM_DEVICE for RDMA READ
> + *
> + * Returns the number of WQEs that will be needed on the workqueue if
> + * successful, or a negative error code.
> + */
> +int rdma_rw_ctx_dma_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
> +		u8 port_num, dma_addr_t addr, u32 len, u64 remote_addr,
> +		u32 rkey, enum dma_data_direction dir)

Why not keep the same basic signature here but replace the scatterlist
with the dma vec ?

> +{
> +	struct scatterlist sg;
> +
> +	sg_dma_address(&sg) = addr;
> +	sg_dma_len(&sg) = len;

This needs to fail if the driver is one of the few that require
struct page to work..

Really want I want to do is to have this new 'dma vec' pushed through
the RDMA APIs so we know that if a driver is using the dma vec
interface it is struct page free.

This is not so hard to do, as most drivers are already struct page
free, but is pretty much blocked on needing some way to go from the
block layer SGL world to the dma vec world that does not hurt storage
performance.

I am hoping that the biovec dma mapping that CH has talked about will
give the missing pieces.

FWIW, rdma is one of the places that is largely struct page free, and
has few problems to natively handle a 'dma vec' from top to bottom, so
I do like this approach.

Someone would have to look carefully at siw, rxe and hfi/qib to see
how they could continue to work with a dma vec, as they do actually
seem to need to kmap the data they are transferring. However, I
thought they were using custom dma ops these days, so maybe they just
encode a struct page in their dma vec and reject p2p entirely?

Jason
