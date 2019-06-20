From: Logan Gunthorpe <logang@deltatee.com>
Subject: [RFC PATCH 19/28] nvme-pci: Support dma-direct bios
Date: Thu, 20 Jun 2019 10:12:31 -0600
Message-ID: <20190620161240.22738-20-logang@deltatee.com>
References: <20190620161240.22738-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190620161240.22738-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Stephen Bates <sbates@raithlin.com>, Logan Gunthorpe <logang@deltatee.com>
List-Id: linux-rdma@vger.kernel.org

Adding support for dma-direct bios only requires putting a condition
around the call to dma_map_sg() so it is skipped when the request
has the REQ_DMA_ADDR flag.

We then need to indicate support for the queue in much the same way
we did with PCI P2PDMA. Seeing this provides the same support as
PCI P2PDMA those flags will be removed in a subsequent patch.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/nvme/host/core.c |  2 ++
 drivers/nvme/host/nvme.h |  1 +
 drivers/nvme/host/pci.c  | 10 +++++++---
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 120fb593d1da..8e876417c44b 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3259,6 +3259,8 @@ static int nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, ns->queue);
 	if (ctrl->ops->flags & NVME_F_PCI_P2PDMA)
 		blk_queue_flag_set(QUEUE_FLAG_PCI_P2PDMA, ns->queue);
+	if (ctrl->ops->flags & NVME_F_DMA_DIRECT)
+		blk_queue_flag_set(QUEUE_FLAG_DMA_DIRECT, ns->queue);
 
 	ns->queue->queuedata = ns;
 	ns->ctrl = ctrl;
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 55553d293a98..f1dddc95c6a8 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -362,6 +362,7 @@ struct nvme_ctrl_ops {
 #define NVME_F_FABRICS			(1 << 0)
 #define NVME_F_METADATA_SUPPORTED	(1 << 1)
 #define NVME_F_PCI_P2PDMA		(1 << 2)
+#define NVME_F_DMA_DIRECT		(1 << 3)
 	int (*reg_read32)(struct nvme_ctrl *ctrl, u32 off, u32 *val);
 	int (*reg_write32)(struct nvme_ctrl *ctrl, u32 off, u32 val);
 	int (*reg_read64)(struct nvme_ctrl *ctrl, u32 off, u64 *val);
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 524d6bd6d095..5957f3a4f261 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -565,7 +565,8 @@ static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
 	WARN_ON_ONCE(!iod->nents);
 
 	/* P2PDMA requests do not need to be unmapped */
-	if (!is_pci_p2pdma_page(sg_page(iod->sg)))
+	if (!is_pci_p2pdma_page(sg_page(iod->sg)) &&
+	    !blk_rq_is_dma_direct(req))
 		dma_unmap_sg(dev->dev, iod->sg, iod->nents, rq_dma_dir(req));
 
 
@@ -824,7 +825,7 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
 	blk_status_t ret = BLK_STS_RESOURCE;
 	int nr_mapped;
 
-	if (blk_rq_nr_phys_segments(req) == 1) {
+	if (blk_rq_nr_phys_segments(req) == 1 && !blk_rq_is_dma_direct(req)) {
 		struct bio_vec bv = req_bvec(req);
 
 		if (!is_pci_p2pdma_page(bv.bv_page)) {
@@ -851,6 +852,8 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
 	if (is_pci_p2pdma_page(sg_page(iod->sg)))
 		nr_mapped = pci_p2pdma_map_sg(dev->dev, iod->sg, iod->nents,
 					      rq_dma_dir(req));
+	else if (blk_rq_is_dma_direct(req))
+		nr_mapped = iod->nents;
 	else
 		nr_mapped = dma_map_sg_attrs(dev->dev, iod->sg, iod->nents,
 					     rq_dma_dir(req), DMA_ATTR_NO_WARN);
@@ -2639,7 +2642,8 @@ static const struct nvme_ctrl_ops nvme_pci_ctrl_ops = {
 	.name			= "pcie",
 	.module			= THIS_MODULE,
 	.flags			= NVME_F_METADATA_SUPPORTED |
-				  NVME_F_PCI_P2PDMA,
+				  NVME_F_PCI_P2PDMA |
+				  NVME_F_DMA_DIRECT,
 	.reg_read32		= nvme_pci_reg_read32,
 	.reg_write32		= nvme_pci_reg_write32,
 	.reg_read64		= nvme_pci_reg_read64,
-- 
2.20.1
