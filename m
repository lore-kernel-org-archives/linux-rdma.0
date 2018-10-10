From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH 1/3] PCI: remove DMA unmap wrappers
Date: Wed, 10 Oct 2018 15:40:22 -0500
Message-ID: <20181010204022.GG5906@bhelgaas-glaptop.roam.corp.google.com>
References: <20181009140824.18667-1-hch@lst.de>
 <20181009140824.18667-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181009140824.18667-2-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org, Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

[+cc folks from MAINTAINERS]

On Tue, Oct 09, 2018 at 04:08:22PM +0200, Christoph Hellwig wrote:
> Only some of these were still used by the cxgb4 driver, and that despite
> the fact that the driver otherwise uses the generic DMA API.

This is trivial and I intend to apply it, so just copying cxgb4 folks
as FYI.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/infiniband/hw/cxgb4/qp.c | 10 +++++-----
>  drivers/infiniband/hw/cxgb4/t4.h |  2 +-
>  include/linux/pci-dma.h          | 12 ------------
>  include/linux/pci.h              |  1 -
>  4 files changed, 6 insertions(+), 19 deletions(-)
>  delete mode 100644 include/linux/pci-dma.h
> 
> diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
> index 347fe18b1a41..62d6f197ec0b 100644
> --- a/drivers/infiniband/hw/cxgb4/qp.c
> +++ b/drivers/infiniband/hw/cxgb4/qp.c
> @@ -99,7 +99,7 @@ static void dealloc_oc_sq(struct c4iw_rdev *rdev, struct t4_sq *sq)
>  static void dealloc_host_sq(struct c4iw_rdev *rdev, struct t4_sq *sq)
>  {
>  	dma_free_coherent(&(rdev->lldi.pdev->dev), sq->memsize, sq->queue,
> -			  pci_unmap_addr(sq, mapping));
> +			  dma_unmap_addr(sq, mapping));
>  }
>  
>  static void dealloc_sq(struct c4iw_rdev *rdev, struct t4_sq *sq)
> @@ -132,7 +132,7 @@ static int alloc_host_sq(struct c4iw_rdev *rdev, struct t4_sq *sq)
>  	if (!sq->queue)
>  		return -ENOMEM;
>  	sq->phys_addr = virt_to_phys(sq->queue);
> -	pci_unmap_addr_set(sq, mapping, sq->dma_addr);
> +	dma_unmap_addr_set(sq, mapping, sq->dma_addr);
>  	return 0;
>  }
>  
> @@ -2521,7 +2521,7 @@ static void free_srq_queue(struct c4iw_srq *srq, struct c4iw_dev_ucontext *uctx,
>  
>  	dma_free_coherent(&rdev->lldi.pdev->dev,
>  			  wq->memsize, wq->queue,
> -			pci_unmap_addr(wq, mapping));
> +			dma_unmap_addr(wq, mapping));
>  	c4iw_rqtpool_free(rdev, wq->rqt_hwaddr, wq->rqt_size);
>  	kfree(wq->sw_rq);
>  	c4iw_put_qpid(rdev, wq->qid, uctx);
> @@ -2570,7 +2570,7 @@ static int alloc_srq_queue(struct c4iw_srq *srq, struct c4iw_dev_ucontext *uctx,
>  		goto err_free_rqtpool;
>  
>  	memset(wq->queue, 0, wq->memsize);
> -	pci_unmap_addr_set(wq, mapping, wq->dma_addr);
> +	dma_unmap_addr_set(wq, mapping, wq->dma_addr);
>  
>  	wq->bar2_va = c4iw_bar2_addrs(rdev, wq->qid, T4_BAR2_QTYPE_EGRESS,
>  				      &wq->bar2_qid,
> @@ -2649,7 +2649,7 @@ static int alloc_srq_queue(struct c4iw_srq *srq, struct c4iw_dev_ucontext *uctx,
>  err_free_queue:
>  	dma_free_coherent(&rdev->lldi.pdev->dev,
>  			  wq->memsize, wq->queue,
> -			pci_unmap_addr(wq, mapping));
> +			dma_unmap_addr(wq, mapping));
>  err_free_rqtpool:
>  	c4iw_rqtpool_free(rdev, wq->rqt_hwaddr, wq->rqt_size);
>  err_free_pending_wrs:
> diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
> index e42021fd6fd6..fff6d48d262f 100644
> --- a/drivers/infiniband/hw/cxgb4/t4.h
> +++ b/drivers/infiniband/hw/cxgb4/t4.h
> @@ -397,7 +397,7 @@ struct t4_srq_pending_wr {
>  struct t4_srq {
>  	union t4_recv_wr *queue;
>  	dma_addr_t dma_addr;
> -	DECLARE_PCI_UNMAP_ADDR(mapping);
> +	DEFINE_DMA_UNMAP_ADDR(mapping);
>  	struct t4_swrqe *sw_rq;
>  	void __iomem *bar2_va;
>  	u64 bar2_pa;
> diff --git a/include/linux/pci-dma.h b/include/linux/pci-dma.h
> deleted file mode 100644
> index 0f7aa7353ca3..000000000000
> --- a/include/linux/pci-dma.h
> +++ /dev/null
> @@ -1,12 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> -#ifndef _LINUX_PCI_DMA_H
> -#define _LINUX_PCI_DMA_H
> -
> -#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME) DEFINE_DMA_UNMAP_ADDR(ADDR_NAME);
> -#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)   DEFINE_DMA_UNMAP_LEN(LEN_NAME);
> -#define pci_unmap_addr             dma_unmap_addr
> -#define pci_unmap_addr_set         dma_unmap_addr_set
> -#define pci_unmap_len              dma_unmap_len
> -#define pci_unmap_len_set          dma_unmap_len_set
> -
> -#endif
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 6925828f9f25..e938e80e59c1 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1342,7 +1342,6 @@ int pci_set_vga_state(struct pci_dev *pdev, bool decode,
>  
>  /* kmem_cache style wrapper around pci_alloc_consistent() */
>  
> -#include <linux/pci-dma.h>
>  #include <linux/dmapool.h>
>  
>  #define	pci_pool dma_pool
> -- 
> 2.19.0
> 
