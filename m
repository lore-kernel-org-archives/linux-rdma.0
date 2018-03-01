From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v2 06/10] IB/core: Add optional PCI P2P flag to
 rdma_rw_ctx_[init|destroy]()
Date: Thu, 1 Mar 2018 12:32:45 +0200
Message-ID: <72e90cc2-c05a-3ed8-42c7-e4d7a0d535d8@grimberg.me>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-7-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180228234006.21093-7-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 03/01/2018 01:40 AM, Logan Gunthorpe wrote:
> In order to use PCI P2P memory pci_p2pmem_[un]map_sg() functions must be
> called to map the correct DMA address. To do this, we add a flags
> variable and the RDMA_RW_CTX_FLAG_PCI_P2P flag. When the flag is
> specified use the appropriate map function.
> 
> Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
> ---
>   drivers/infiniband/core/rw.c            | 21 +++++++++++++++++----
>   drivers/infiniband/ulp/isert/ib_isert.c |  5 +++--
>   drivers/infiniband/ulp/srpt/ib_srpt.c   |  7 ++++---
>   drivers/nvme/target/rdma.c              |  6 +++---
>   include/rdma/rw.h                       |  7 +++++--
>   net/sunrpc/xprtrdma/svc_rdma_rw.c       |  6 +++---
>   6 files changed, 35 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
> index c8963e91f92a..775a9f8b15a6 100644
> --- a/drivers/infiniband/core/rw.c
> +++ b/drivers/infiniband/core/rw.c
> @@ -12,6 +12,7 @@
>    */
>   #include <linux/moduleparam.h>
>   #include <linux/slab.h>
> +#include <linux/pci-p2pdma.h>
>   #include <rdma/mr_pool.h>
>   #include <rdma/rw.h>
>   
> @@ -269,18 +270,24 @@ static int rdma_rw_init_single_wr(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
>    * @remote_addr:remote address to read/write (relative to @rkey)
>    * @rkey:	remote key to operate on
>    * @dir:	%DMA_TO_DEVICE for RDMA WRITE, %DMA_FROM_DEVICE for RDMA READ
> + * @flags:      any of the RDMA_RW_CTX_FLAG_* flags
>    *
>    * Returns the number of WQEs that will be needed on the workqueue if
>    * successful, or a negative error code.
>    */
>   int rdma_rw_ctx_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
>   		struct scatterlist *sg, u32 sg_cnt, u32 sg_offset,
> -		u64 remote_addr, u32 rkey, enum dma_data_direction dir)
> +		u64 remote_addr, u32 rkey, enum dma_data_direction dir,
> +		unsigned int flags)
>   {
>   	struct ib_device *dev = qp->pd->device;
>   	int ret;
>   
> -	ret = ib_dma_map_sg(dev, sg, sg_cnt, dir);
> +	if (flags & RDMA_RW_CTX_FLAG_PCI_P2PDMA)
> +		ret = pci_p2pdma_map_sg(dev->dma_device, sg, sg_cnt, dir);
> +	else
> +		ret = ib_dma_map_sg(dev, sg, sg_cnt, dir);
> +

Why not use is_pci_p2pdma_page(sg) instead of a flag? It would be so
much cleaner...
