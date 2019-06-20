From: Logan Gunthorpe <logang@deltatee.com>
Subject: [RFC PATCH 23/28] nvme-pci: Remove support for PCI_P2PDMA requests
Date: Thu, 20 Jun 2019 10:12:35 -0600
Message-ID: <20190620161240.22738-24-logang@deltatee.com>
References: <20190620161240.22738-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190620161240.22738-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Stephen Bates <sbates@raithlin.com>, Logan Gunthorpe <logang@deltatee.com>
List-Id: linux-rdma@vger.kernel.org

These requests have been superseded by dma-direct requests and are
therefore no longer needed.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/nvme/host/core.c |  2 --
 drivers/nvme/host/nvme.h |  3 +--
 drivers/nvme/host/pci.c  | 27 ++++++++++-----------------
 3 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 8e876417c44b..63d132c478b4 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3257,8 +3257,6 @@ static int nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 	}
 
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, ns->queue);
-	if (ctrl->ops->flags & NVME_F_PCI_P2PDMA)
-		blk_queue_flag_set(QUEUE_FLAG_PCI_P2PDMA, ns->queue);
 	if (ctrl->ops->flags & NVME_F_DMA_DIRECT)
 		blk_queue_flag_set(QUEUE_FLAG_DMA_DIRECT, ns->queue);
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index f1dddc95c6a8..d103cecc14dd 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -361,8 +361,7 @@ struct nvme_ctrl_ops {
 	unsigned int flags;
 #define NVME_F_FABRICS			(1 << 0)
 #define NVME_F_METADATA_SUPPORTED	(1 << 1)
-#define NVME_F_PCI_P2PDMA		(1 << 2)
-#define NVME_F_DMA_DIRECT		(1 << 3)
+#define NVME_F_DMA_DIRECT		(1 << 2)
 	int (*reg_read32)(struct nvme_ctrl *ctrl, u32 off, u32 *val);
 	int (*reg_write32)(struct nvme_ctrl *ctrl, u32 off, u32 val);
 	int (*reg_read64)(struct nvme_ctrl *ctrl, u32 off, u64 *val);
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 5957f3a4f261..7f806e76230a 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -564,9 +564,8 @@ static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
 
 	WARN_ON_ONCE(!iod->nents);
 
-	/* P2PDMA requests do not need to be unmapped */
-	if (!is_pci_p2pdma_page(sg_page(iod->sg)) &&
-	    !blk_rq_is_dma_direct(req))
+	/* DMA direct requests do not need to be unmapped */
+	if (!blk_rq_is_dma_direct(req))
 		dma_unmap_sg(dev->dev, iod->sg, iod->nents, rq_dma_dir(req));
 
 
@@ -828,16 +827,14 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
 	if (blk_rq_nr_phys_segments(req) == 1 && !blk_rq_is_dma_direct(req)) {
 		struct bio_vec bv = req_bvec(req);
 
-		if (!is_pci_p2pdma_page(bv.bv_page)) {
-			if (bv.bv_offset + bv.bv_len <= dev->ctrl.page_size * 2)
-				return nvme_setup_prp_simple(dev, req,
-							     &cmnd->rw, &bv);
+		if (bv.bv_offset + bv.bv_len <= dev->ctrl.page_size * 2)
+			return nvme_setup_prp_simple(dev, req,
+						     &cmnd->rw, &bv);
 
-			if (iod->nvmeq->qid &&
-			    dev->ctrl.sgls & ((1 << 0) | (1 << 1)))
-				return nvme_setup_sgl_simple(dev, req,
-							     &cmnd->rw, &bv);
-		}
+		if (iod->nvmeq->qid &&
+		    dev->ctrl.sgls & ((1 << 0) | (1 << 1)))
+			return nvme_setup_sgl_simple(dev, req,
+						     &cmnd->rw, &bv);
 	}
 
 	iod->dma_len = 0;
@@ -849,10 +846,7 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
 	if (!iod->nents)
 		goto out;
 
-	if (is_pci_p2pdma_page(sg_page(iod->sg)))
-		nr_mapped = pci_p2pdma_map_sg(dev->dev, iod->sg, iod->nents,
-					      rq_dma_dir(req));
-	else if (blk_rq_is_dma_direct(req))
+	if (blk_rq_is_dma_direct(req))
 		nr_mapped = iod->nents;
 	else
 		nr_mapped = dma_map_sg_attrs(dev->dev, iod->sg, iod->nents,
@@ -2642,7 +2636,6 @@ static const struct nvme_ctrl_ops nvme_pci_ctrl_ops = {
 	.name			= "pcie",
 	.module			= THIS_MODULE,
 	.flags			= NVME_F_METADATA_SUPPORTED |
-				  NVME_F_PCI_P2PDMA |
 				  NVME_F_DMA_DIRECT,
 	.reg_read32		= nvme_pci_reg_read32,
 	.reg_write32		= nvme_pci_reg_write32,
-- 
2.20.1
