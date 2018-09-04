From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH v5 10/13] nvme-pci: Add support for P2P memory in requests
Date: Tue, 4 Sep 2018 09:16:38 -0600
Message-ID: <20180904151638.GL335@mellanox.com>
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830185352.3369-11-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180830185352.3369-11-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, Stephen Bates <sbates@raithlin.com>, Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 30, 2018 at 12:53:49PM -0600, Logan Gunthorpe wrote:
> For P2P requests, we must use the pci_p2pmem_map_sg() function
> instead of the dma_map_sg functions.
> 
> With that, we can then indicate PCI_P2P support in the request queue.
> For this, we create an NVME_F_PCI_P2P flag which tells the core to
> set QUEUE_FLAG_PCI_P2P in the request queue.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>  drivers/nvme/host/core.c |  4 ++++
>  drivers/nvme/host/nvme.h |  1 +
>  drivers/nvme/host/pci.c  | 17 +++++++++++++----
>  3 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index dd8ec1dd9219..6033ce2fd3e9 100644
> +++ b/drivers/nvme/host/core.c
> @@ -3051,7 +3051,11 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid)
>  	ns->queue = blk_mq_init_queue(ctrl->tagset);
>  	if (IS_ERR(ns->queue))
>  		goto out_free_ns;
> +
>  	blk_queue_flag_set(QUEUE_FLAG_NONROT, ns->queue);
> +	if (ctrl->ops->flags & NVME_F_PCI_P2PDMA)
> +		blk_queue_flag_set(QUEUE_FLAG_PCI_P2PDMA, ns->queue);
> +
>  	ns->queue->queuedata = ns;
>  	ns->ctrl = ctrl;
>  
> diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
> index bb4a2003c097..4030743c90aa 100644
> +++ b/drivers/nvme/host/nvme.h
> @@ -343,6 +343,7 @@ struct nvme_ctrl_ops {
>  	unsigned int flags;
>  #define NVME_F_FABRICS			(1 << 0)
>  #define NVME_F_METADATA_SUPPORTED	(1 << 1)
> +#define NVME_F_PCI_P2PDMA		(1 << 2)
>  	int (*reg_read32)(struct nvme_ctrl *ctrl, u32 off, u32 *val);
>  	int (*reg_write32)(struct nvme_ctrl *ctrl, u32 off, u32 val);
>  	int (*reg_read64)(struct nvme_ctrl *ctrl, u32 off, u64 *val);
> diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> index 2902585c6ddf..bb2120d30e39 100644
> +++ b/drivers/nvme/host/pci.c
> @@ -737,8 +737,13 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
>  		goto out;
>  
>  	ret = BLK_STS_RESOURCE;
> -	nr_mapped = dma_map_sg_attrs(dev->dev, iod->sg, iod->nents, dma_dir,
> -			DMA_ATTR_NO_WARN);
> +
> +	if (is_pci_p2pdma_page(sg_page(iod->sg)))
> +		nr_mapped = pci_p2pdma_map_sg(dev->dev, iod->sg, iod->nents,
> +					  dma_dir);
> +	else
> +		nr_mapped = dma_map_sg_attrs(dev->dev, iod->sg, iod->nents,
> +					     dma_dir,  DMA_ATTR_NO_WARN);
>  	if (!nr_mapped)
>  		goto out;
>  
> @@ -780,7 +785,10 @@ static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
>  			DMA_TO_DEVICE : DMA_FROM_DEVICE;
>  
>  	if (iod->nents) {
> -		dma_unmap_sg(dev->dev, iod->sg, iod->nents, dma_dir);
> +		/* P2PDMA requests do not need to be unmapped */
> +		if (!is_pci_p2pdma_page(sg_page(iod->sg)))
> +			dma_unmap_sg(dev->dev, iod->sg, iod->nents, dma_dir);

This seems like a poor direction, if we add IOMMU hairpin support we
will need unmapping.

Jason
